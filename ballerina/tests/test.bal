// Copyright (c) 2024, WSO2 LLC. (http://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/test;
import ballerina/io;

configurable boolean isLiveServer = ?;
configurable string token = ?;
configurable string serviceUrl = isLiveServer ? "https://api.openai.com/v1" : "http://localhost:9090";

ConnectionConfig config = {
    auth: {
        token
    }
};

public type DataPassingObject record{
    string assistantId ="";
    string threadId = "";
    string messageId = "";
    string runId = "";
    string stepId = "";
};

DataPassingObject dataPasser = {};

final Client AssistantClient = check new(config,serviceUrl);

const map<string|string[]> headers = {
    "OpenAI-Beta": ["assistants=v2"]
};

function dataGen() returns DataPassingObject[][] {
    return [[dataPasser]];
}

@test:Config {dataProvider:  dataGen, dependsOn: [testCreateMessage, testCreateThread, testGetMessage]}
isolated function  testDeleteMessage(DataPassingObject dataPasser) {
    // Ensure threadId and messageId are not empty
    if (dataPasser.threadId == "" || dataPasser.messageId == "") {
        test:assertFail(msg = "No thread ID or message ID available. Ensure message creation test runs first.");
    }

    // Delete the message
    DeleteMessageResponse|error res = AssistantClient->/threads/[dataPasser.threadId]/messages/[dataPasser.messageId].delete(headers);
    if (res is DeleteMessageResponse) {
        io:println("Message deleted successfully: ", res);
        test:assertTrue(res.deleted == true, msg = "Failed to delete message");
    } else {
        test:assertFail(msg = "Failed to delete message");
    }
}

@test:Config {dataProvider:  dataGen, dependsOn: [testCreateThread, testCreateMessage]}
isolated function  testGetMessage(DataPassingObject dataPasser) {
        // Ensure threadId and messageId are not empty
    if (dataPasser.threadId == "" || dataPasser.messageId == "") {
        test:assertFail(msg = "No thread ID or message ID available. Ensure thread creation and message creation tests run first.");
    }

    // Retrieve a specific message in the thread
    MessageObject|error res = AssistantClient->/threads/[dataPasser.threadId]/messages/[dataPasser.messageId].get(headers);
    
    if (res is MessageObject) {
        // io:println("Message Details: ", res);
        test:assertEquals(res.id, dataPasser.messageId, msg = "Retrieved message ID does not match the requested ID");
    } else {
        test:assertFail(msg = "Failed to retrieve the message in the thread");
    }
}

@test:Config {dataProvider:  dataGen, dependsOn: [testCreateThread]}
isolated function  testCreateMessage(DataPassingObject dataPasser) {
    // Ensure threadId is not empty
    if (dataPasser.threadId == "") {
        test:assertFail(msg = "No thread ID available. Ensure testCreateThread runs first.");
    }

    CreateMessageRequest createMsgReq = {
        role: "user",
        content: "Can you help me solve the equation `3x + 11 = 14`?"
    };

    MessageObject|error res = AssistantClient->/threads/[dataPasser.threadId]/messages.post(createMsgReq, headers);
    if (res is MessageObject) {
        io:println("Created Message: ", res);
        test:assertNotEquals(res.id, "");
        dataPasser.messageId = res.id;
    } else {
        test:assertFail(msg = "Failed to create message");
    }
}

@test:Config {dataProvider:  dataGen, dependsOn: [testCreateThread]}
isolated function  testListMessages(DataPassingObject dataPasser) {
    // Ensure threadId is not empty
    if (dataPasser.threadId == "") {
        test:assertFail(msg = "No thread ID available. Ensure thread creation test runs first.");
    }

    // List all messages in the thread
    ListMessagesResponse|error res = AssistantClient->/threads/[dataPasser.threadId]/messages.get(headers);
    io:println("ListMessagesResponse: ", res);
    test:assertTrue(res is ListMessagesResponse);
}


@test:Config {dataProvider:  dataGen, dependsOn: [testCreateThread,testCreateAssistant]}
isolated function  testCreateRun(DataPassingObject dataPasser) {
    CreateRunRequest runReq = {
        assistant_id: dataPasser.assistantId, 
        model: "gpt-3.5-turbo",
        instructions: "You are a personal math tutor. Assist the user with their math questions.",
        temperature: 0.7,
        top_p: 0.9,
        max_prompt_tokens: 400,
        max_completion_tokens: 200
    };

    RunObject|error resp = AssistantClient->/threads/[dataPasser.threadId]/runs.post(runReq, headers);
    if (resp is RunObject) {
        // io:println("Created Run: ", resp);
        test:assertNotEquals(resp.id, "", msg = "Run creation failed: No Run ID returned");
        dataPasser.runId = resp.id;
    } else {
        test:assertFail(msg = "Failed to create a run");
    }
}

@test:Config {dataProvider:  dataGen, dependsOn: [testCreateThread]}
isolated function  testListRuns(DataPassingObject dataPasser) returns error? {
    ListRunsResponse|error res = AssistantClient->/threads/[dataPasser.threadId]/runs.get(headers);
    if (res is ListRunsResponse) {
        // io:println("Runs in Thread: ", res.data);
        test:assertNotEquals(res.data.length(), 0, msg = "No runs found in the thread");
    } else {
        test:assertFail(msg = "Failed to list runs in the thread");
    }
}

@test:Config {dependsOn: [testCreateAssistant]}
isolated function  testCreateThreadAndRun() {
    CreateThreadAndRunRequest createThreadAndRunReq = {
        assistant_id: dataPasser.assistantId, 
        model: "gpt-3.5-turbo",
        instructions: "You are a personal math tutor. Assist the user with their math questions.",
        temperature: 0.7,
        top_p: 0.9,
        max_prompt_tokens: 400,
        max_completion_tokens: 200
    };

    var resp = AssistantClient->/threads/runs.post(createThreadAndRunReq, headers);
    if (resp is RunObject) {
        io:println("Created Thread and Run: ", resp);
        test:assertNotEquals(resp.id, "", msg = "Thread and Run creation failed: No Run ID returned");
    } else {
        test:assertFail(msg = "Failed to create thread and run");
    }
}

@test:Config {dataProvider:  dataGen}
isolated function  testCreateThread(DataPassingObject dataPasser) {
    CreateThreadRequest createThreadReq = {
        messages: []
    };
    
    ThreadObject|error response = AssistantClient->/threads.post(createThreadReq, headers);
    if (response is ThreadObject) {
        io:println("Thread ID: ", response.id);
        dataPasser.threadId = response.id;
        test:assertNotEquals(response.id, "");
    } else {
        test:assertFail(msg = "Failed to create thread");
    }
}

@test:Config {dataProvider:  dataGen, dependsOn: [testCreateAssistant, testGetAssistant, testCreateRun, testGetRunStep, testGetRun, testListRunSteps]}
isolated function  testDeleteAssistant(DataPassingObject dataPasser) {
    // Ensure assistantId is not empty
    if (dataPasser.assistantId == "") {
        test:assertFail(msg = "No assistant ID available. Ensure assistant creation test runs first.");
    }

    // Delete the assistant
    DeleteAssistantResponse|error res = AssistantClient->/assistants/[dataPasser.assistantId].delete(headers);
    if (res is DeleteAssistantResponse) {
        io:println("Assistant deleted successfully: ", res);
        test:assertTrue(res.deleted == true, msg = "Failed to delete assistant");
    } else {
        test:assertFail(msg = "Failed to delete assistant");
    }
}

@test:Config {dataProvider:  dataGen, dependsOn: [testCreateAssistant]}
isolated function  testGetAssistant(DataPassingObject dataPasser) {
        // Ensure assistantId is not empty
    if (dataPasser.assistantId == "") {
        test:assertFail(msg = "No assistant ID available. Ensure you set assistantId before running this test.");
    }

    // Get assistant details by assistantId
    AssistantObject|error res = AssistantClient->/assistants/[dataPasser.assistantId].get(headers);
    if (res is AssistantObject) {
        // io:println("Assistant Details: ", res);
        test:assertEquals(res.id, dataPasser.assistantId);
    } else {
        test:assertFail(msg = "Failed to retrieve assistant by ID");
    }
}

@test:Config {dataProvider:  dataGen, dependsOn: [testCreateRun]}
isolated function  testListRunSteps(DataPassingObject dataPasser) {
    ListRunStepsResponse|error res = AssistantClient->/threads/[dataPasser.threadId]/runs/[dataPasser.runId]/steps.get(headers);
    test:assertTrue(res is ListRunStepsResponse);
    if (res is ListRunStepsResponse) {
        io:println("Steps in Run: ", res.data);
        dataPasser.stepId = res.data.length()> 0 ? res.data[0].id:"";
    }
}

@test:Config {dataProvider: dataGen}
isolated function  testCreateAssistant(DataPassingObject dataPasser) {
    AssistantToolsCode codeTool = {
        'type: "code_interpreter"
    };

    CreateAssistantRequest request = {
        model: "gpt-3.5-turbo",
        name: "Math Tutor",
        description: "An Assistant for personal math tutoring",
        instructions: "You are a personal math tutor. Help the user with their math questions.",
        tools: [codeTool]
    };

    AssistantObject|error res = AssistantClient->/assistants.post(request, headers);
    if (res is AssistantObject) {
        io:println("Assistant ID: ", res.id);
        dataPasser.assistantId = res.id;
        test:assertNotEquals(res.id, "");
    } else {
        test:assertFail(msg = "Failed to create assistant");
    }
}

@test:Config {}
isolated function  testListAssistants() {

    ListAssistantsQueries query = {
        before: "",
        after: ""
    };

    ListAssistantsResponse|error res = AssistantClient->/assistants.get(headers, query);
    if (res is ListAssistantsResponse) {
        // io:println("Assistant List: ", res.data);
        test:assertNotEquals(res.data.length(), 0);
    } else {
        test:assertFail(msg = "Failed to get assistant list");
    }
}

@test:Config {dataProvider:  dataGen, dependsOn: [testCreateRun]}
isolated function  testGetRunStep(DataPassingObject dataPasser) {
    if dataPasser.stepId == ""{
        test:assertEquals(dataPasser.stepId, "");
    }
    else{
        RunStepObject|error res = AssistantClient->/threads/[dataPasser.threadId]/runs/[dataPasser.runId]/steps/[dataPasser.stepId].get(headers);
        if (res is RunStepObject) {
            // io:println("Run Step Details: ", res);
            test:assertEquals(res.id, dataPasser.stepId, msg = "Retrieved step ID does not match the requested ID");
        } else {
            test:assertFail(msg = "Failed to retrieve the run step in the run");
        }
    }
    
}


@test:Config {dataProvider:  dataGen, dependsOn: [testCreateThread, testCreateMessage, testDeleteMessage,testGetThread,testListMessages, testGetRunStep,testGetRun, testListRunSteps, testListRuns]}
isolated function  testDeleteThread(DataPassingObject dataPasser) {
    // Ensure threadId is not empty
    if (dataPasser.threadId == "") {
        test:assertFail(msg = "No thread ID available. Ensure thread creation test runs first.");
    }

    // Delete the thread
    DeleteThreadResponse|error res = AssistantClient->/threads/[dataPasser.threadId].delete(headers);
    if (res is DeleteThreadResponse) {
        io:println("Thread deleted successfully: ", res);
        test:assertTrue(res.deleted == true, msg = "Failed to delete thread");
    } else {
        test:assertFail(msg = "Failed to delete thread");
    }
}

@test:Config {dataProvider:  dataGen, dependsOn: [testCreateThread]}
isolated function  testGetThread(DataPassingObject dataPasser) {
        // Ensure threadId is not empty
    if (dataPasser.threadId == "") {
        test:assertFail(msg = "No thread ID available. Ensure testCreateThread runs first.");
    }

    // Get thread details by threadId
    ThreadObject|error res = AssistantClient->/threads/[dataPasser.threadId].get(headers);
    if (res is ThreadObject) {
        // io:println("Thread Details: ", res);
        test:assertEquals(res.id, dataPasser.threadId);
    } else {
        test:assertFail(msg = "Failed to retrieve thread by ID");
    }

}

@test:Config {dataProvider:  dataGen, dependsOn: [testCreateRun]}
isolated function  testGetRun(DataPassingObject dataPasser) {
    RunObject|error res = AssistantClient->/threads/[dataPasser.threadId]/runs/[dataPasser.runId].get(headers);
    if (res is RunObject) {
        io:println("Run Details: ", res);
        test:assertEquals(res.id, dataPasser.runId, msg = "Retrieved run ID does not match the requested ID");
    } else {
        test:assertFail(msg = "Failed to retrieve the run in the thread");
    }

}
