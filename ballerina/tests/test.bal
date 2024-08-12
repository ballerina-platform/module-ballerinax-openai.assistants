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

import ballerina/io;
import ballerina/test;

configurable boolean isLiveServer = ?;
configurable string token = ?;
configurable string serviceUrl = isLiveServer ? "https://api.openai.com/v1" : "http://localhost:9090";

ConnectionConfig config = {
    auth: {
        token
    }
};
final Client AssistantClient = check new (config, serviceUrl);


public type DataPassingObject record {
    string assistantId = "";
    string threadId = "";
    string messageId = "";
    string runId = "";
    string stepId = "";
};

DataPassingObject dataPasser = {};

const map<string|string[]> headers = {
    "OpenAI-Beta": ["assistants=v2"]
};

function dataGen() returns DataPassingObject[][] {
    return [[dataPasser]];
}

@test:Config {dataProvider: dataGen, dependsOn: [testCreateMessage, testCreateThread, testGetMessage]}
isolated function testDeleteMessage(DataPassingObject dataPasser) returns error?{
    
    if (dataPasser.threadId == "" || dataPasser.messageId == "") {
        test:assertFail(msg = "No thread ID or message ID available. Ensure message creation test runs first.");
    }

    DeleteMessageResponse res = check AssistantClient->/threads/[dataPasser.threadId]/messages/[dataPasser.messageId].delete(headers);
    io:println("Message deleted successfully: ", res);
    test:assertTrue(res.deleted == true, msg = "Failed to delete message");

}

@test:Config {dataProvider: dataGen, dependsOn: [testCreateThread, testCreateMessage]}
isolated function testGetMessage(DataPassingObject dataPasser) returns error?{
    if (dataPasser.threadId == "" || dataPasser.messageId == "") {
        test:assertFail(msg = "No thread ID or message ID available. Ensure thread creation and message creation tests run first.");
    }

    MessageObject res = check AssistantClient->/threads/[dataPasser.threadId]/messages/[dataPasser.messageId].get(headers);
    io:println("Message Details: ", res);
    test:assertEquals(res.id, dataPasser.messageId, msg = "Retrieved message ID does not match the requested ID");

}

@test:Config {dataProvider: dataGen, dependsOn: [testCreateThread]}
isolated function testCreateMessage(DataPassingObject dataPasser) returns error?{
    if (dataPasser.threadId == "") {
        test:assertFail(msg = "No thread ID available. Ensure testCreateThread runs first.");
    }

    CreateMessageRequest createMsgReq = {
        role: "user",
        content: "Can you help me solve the equation `3x + 11 = 14`?"
    };

    MessageObject res = check AssistantClient->/threads/[dataPasser.threadId]/messages.post(createMsgReq, headers);

        io:println("Created Message: ", res);
        test:assertNotEquals(res.id, "");
        dataPasser.messageId = res.id;

}

@test:Config {dataProvider: dataGen, dependsOn: [testCreateThread]}
isolated function testListMessages(DataPassingObject dataPasser) returns error?{
    if (dataPasser.threadId == "") {
        test:assertFail(msg = "No thread ID available. Ensure thread creation test runs first.");
    }

    ListMessagesResponse res = check AssistantClient->/threads/[dataPasser.threadId]/messages.get(headers);
    io:println("ListMessagesResponse: ", res);
    test:assertTrue(res is ListMessagesResponse);
}

@test:Config {dataProvider: dataGen, dependsOn: [testCreateThread, testCreateAssistant]}
isolated function testCreateRun(DataPassingObject dataPasser) returns error?{
    CreateRunRequest runReq = {
        assistant_id: dataPasser.assistantId,
        model: "gpt-3.5-turbo",
        instructions: "You are a personal math tutor. Assist the user with their math questions.",
        temperature: 0.7,
        top_p: 0.9,
        max_prompt_tokens: 400,
        max_completion_tokens: 200
    };

    RunObject resp = check AssistantClient->/threads/[dataPasser.threadId]/runs.post(runReq, headers);
    io:println("Created Run: ", resp);
    test:assertNotEquals(resp.id, "", msg = "Run creation failed: No Run ID returned");
    dataPasser.runId = resp.id;
}

@test:Config {dataProvider: dataGen, dependsOn: [testCreateThread]}
isolated function testListRuns(DataPassingObject dataPasser) returns error? {
    ListRunsResponse res = check AssistantClient->/threads/[dataPasser.threadId]/runs.get(headers);
    io:println("Runs in Thread: ", res.data);
    test:assertNotEquals(res.data.length(), 0, msg = "No runs found in the thread");

}

@test:Config {dependsOn: [testCreateAssistant]}
isolated function testCreateThreadAndRun() returns error?{
    // CreateThreadAndRunRequest createThreadAndRunReq = {
    //     assistant_id: dataPasser.assistantId,
    //     model: "gpt-3.5-turbo",
    //     instructions: "You are a personal math tutor. Assist the user with their math questions.",
    //     temperature: 0.7,
    //     top_p: 0.9,
    //     max_prompt_tokens: 400,
    //     max_completion_tokens: 200
    // };

    // RunObject resp = check AssistantClient->/threads/runs.post(createThreadAndRunReq, headers);

//     io:println("Created Thread and Run: ", resp);
//     test:assertNotEquals(resp.id, "", msg = "Thread and Run creation failed: No Run ID returned");

}

@test:Config {dataProvider: dataGen}
isolated function testCreateThread(DataPassingObject dataPasser) returns error?{
    CreateThreadRequest createThreadReq = {
        messages: []
    };

    ThreadObject response = check AssistantClient->/threads.post(createThreadReq, headers);
    io:println("Thread ID: ", response.id);
    dataPasser.threadId = response.id;
    test:assertNotEquals(response.id, "");

}

@test:Config {dataProvider: dataGen, dependsOn: [testCreateAssistant, testGetAssistant, testCreateRun, testGetRunStep, testGetRun, testListRunSteps]}
isolated function testDeleteAssistant(DataPassingObject dataPasser) returns error?{
    if (dataPasser.assistantId == "") {
        test:assertFail(msg = "No assistant ID available. Ensure assistant creation test runs first.");
    }

    DeleteAssistantResponse res = check AssistantClient->/assistants/[dataPasser.assistantId].delete(headers);
    io:println("Assistant deleted successfully: ", res);
    test:assertTrue(res.deleted == true, msg = "Failed to delete assistant");

}

@test:Config {dataProvider: dataGen, dependsOn: [testCreateAssistant]}
isolated function testGetAssistant(DataPassingObject dataPasser) returns error?{
    if (dataPasser.assistantId == "") {
        test:assertFail(msg = "No assistant ID available. Ensure you set assistantId before running this test.");
    }

    AssistantObject res = check AssistantClient->/assistants/[dataPasser.assistantId].get(headers);
    io:println("Assistant Details: ", res);
    test:assertEquals(res.id, dataPasser.assistantId);

}

@test:Config {dataProvider: dataGen, dependsOn: [testCreateRun]}
isolated function testListRunSteps(DataPassingObject dataPasser) returns error?{
    ListRunStepsResponse res = check AssistantClient->/threads/[dataPasser.threadId]/runs/[dataPasser.runId]/steps.get(headers);
    test:assertTrue(res is ListRunStepsResponse);
    io:println("Steps in Run: ", res.data);
    dataPasser.stepId = res.data.length() > 0 ? res.data[0].id : "";

}

@test:Config {dataProvider: dataGen}
isolated function testCreateAssistant(DataPassingObject dataPasser) returns error?{
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

    AssistantObject res = check AssistantClient->/assistants.post(request, headers);
    io:println("Assistant ID: ", res.id);
    dataPasser.assistantId = res.id;
    test:assertNotEquals(res.id, "");

}

@test:Config {}
isolated function testListAssistants() returns error?{

    ListAssistantsQueries query = {
        before: "",
        after: ""
    };

    ListAssistantsResponse res = check AssistantClient->/assistants.get(headers, query);
    io:println("Assistant List: ", res.data);
    test:assertTrue(res is ListAssistantsResponse);

}

@test:Config {dataProvider: dataGen, dependsOn: [testCreateRun]}
isolated function testGetRunStep(DataPassingObject dataPasser) returns error?{
    if dataPasser.stepId == "" {
        test:assertEquals(dataPasser.stepId, "");
    }
    else {
        RunStepObject res = check AssistantClient->/threads/[dataPasser.threadId]/runs/[dataPasser.runId]/steps/[dataPasser.stepId].get(headers);
        io:println("Run Step Details: ", res);
        test:assertEquals(res.id, dataPasser.stepId, msg = "Retrieved step ID does not match the requested ID");
    }

}

@test:Config {dataProvider: dataGen, dependsOn: [testCreateThread, testCreateMessage, testDeleteMessage, testGetThread, testListMessages, testGetRunStep, testGetRun, testListRunSteps, testListRuns]}
isolated function testDeleteThread(DataPassingObject dataPasser) returns error?{
    if (dataPasser.threadId == "") {
        test:assertFail(msg = "No thread ID available. Ensure thread creation test runs first.");
    }

    DeleteThreadResponse res = check AssistantClient->/threads/[dataPasser.threadId].delete(headers);
    io:println("Thread deleted successfully: ", res);
    test:assertTrue(res.deleted == true, msg = "Failed to delete thread");
}

@test:Config {dataProvider: dataGen, dependsOn: [testCreateThread]}
isolated function testGetThread(DataPassingObject dataPasser) returns error?{
    if (dataPasser.threadId == "") {
        test:assertFail(msg = "No thread ID available. Ensure testCreateThread runs first.");
    }

    ThreadObject res = check AssistantClient->/threads/[dataPasser.threadId].get(headers);
    io:println("Thread Details: ", res);
    test:assertEquals(res.id, dataPasser.threadId);

}

@test:Config {dataProvider: dataGen, dependsOn: [testCreateRun]}
isolated function testGetRun(DataPassingObject dataPasser) returns error?{
    RunObject res = check AssistantClient->/threads/[dataPasser.threadId]/runs/[dataPasser.runId].get(headers);
    io:println("Run Details: ", res);
    test:assertEquals(res.id, dataPasser.runId, msg = "Retrieved run ID does not match the requested ID");
    
}
