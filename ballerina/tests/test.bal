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
import ballerina/os;
import ballerina/test;

configurable boolean isLiveServer = os:getEnv("isLiveServer") == "true";
configurable string token = isLiveServer ? os:getEnv("OPENAI_API_KEY"): "test";
configurable string serviceUrl = isLiveServer ? "https://api.openai.com/v1" : "http://localhost:9090";

ConnectionConfig config = {
    auth: {
        token
    }
};
final Client openAIAssistant = check new (config, serviceUrl);

string assistantId = "";
string threadId = "";
string messageId = "";
string runId = "";
string stepId = "";

const map<string|string[]> headers = {
    "OpenAI-Beta": ["assistants=v2"]
};

@test:Config {
    dependsOn: [testCreateMessage, testCreateThread, testGetMessage],
    groups: ["live_tests", "mock_tests"]
}
function testDeleteMessage() returns error? {
    if threadId == "" || messageId == "" {
        test:assertFail(msg = "No thread ID or message ID available. Ensure message creation test runs first.");
    }

    DeleteMessageResponse res = check openAIAssistant->/threads/[threadId]/messages/[messageId].delete(headers);
    io:println("Message deleted successfully: ", res);
    test:assertTrue(res.deleted == true, msg = "Failed to delete message");
}

@test:Config {
    dependsOn: [testCreateThread, testCreateMessage],
    groups: ["live_tests", "mock_tests"]
}
function testGetMessage() returns error? {
    if threadId == "" || messageId == "" {
        test:assertFail(msg = "No thread ID or message ID available. Ensure thread creation and message creation tests run first.");
    }

    MessageObject res = check openAIAssistant->/threads/[threadId]/messages/[messageId].get(headers);
    io:println("Message Details: ", res);
    test:assertEquals(res.id, messageId, msg = "Retrieved message ID does not match the requested ID");
}

@test:Config {
    dependsOn: [testCreateThread],
    groups: ["live_tests", "mock_tests"]
}
function testCreateMessage() returns error? {
    if threadId == "" {
        test:assertFail(msg = "No thread ID available. Ensure testCreateThread runs first.");
    }

    CreateMessageRequest createMsgReq = {
        role: "user",
        content: "Can you help me solve the equation `3x + 11 = 14`?"
    };

    MessageObject res = check openAIAssistant->/threads/[threadId]/messages.post(createMsgReq, headers);
    io:println("Created Message: ", res);
    test:assertNotEquals(res.id, "");
    messageId = res.id;
}

@test:Config {
    dependsOn: [testCreateThread],
    groups: ["live_tests", "mock_tests"]
}
function testListMessages() returns error? {
    if threadId == "" {
        test:assertFail(msg = "No thread ID available. Ensure thread creation test runs first.");
    }

    ListMessagesResponse res = check openAIAssistant->/threads/[threadId]/messages.get(headers);
    io:println("ListMessagesResponse: ", res);
    test:assertTrue(res is ListMessagesResponse);
}

@test:Config {
    dependsOn: [testCreateThread, testCreateAssistant],
    groups: ["live_tests", "mock_tests"]
}
function testCreateRun() returns error? {
    CreateRunRequest runReq = {
        assistant_id: assistantId,
        model: "gpt-3.5-turbo",
        instructions: "You are a personal math tutor. Assist the user with their math questions.",
        temperature: 0.7,
        top_p: 0.9,
        max_prompt_tokens: 400,
        max_completion_tokens: 200
    };

    RunObject resp = check openAIAssistant->/threads/[threadId]/runs.post(runReq, headers);
    io:println("Created Run: ", resp);
    test:assertNotEquals(resp.id, "", msg = "Run creation failed: No Run ID returned");
    runId = resp.id;
}

@test:Config {
    dependsOn: [testCreateThread],
    groups: ["live_tests", "mock_tests"]
}
function testListRuns() returns error? {
    ListRunsResponse res = check openAIAssistant->/threads/[threadId]/runs.get(headers);
    io:println("Runs in Thread: ", res.data);
    test:assertNotEquals(res.data.length(), 0, msg = "No runs found in the thread");
}

@test:Config {
    dependsOn: [testCreateAssistant],
    groups: ["live_tests", "mock_tests"]
}
function testCreateThreadAndRun() returns error? {
    // CreateThreadAndRunRequest createThreadAndRunReq = {
    //     assistant_id: assistantId,
    //     model: "gpt-3.5-turbo",
    //     instructions: "You are a personal math tutor. Assist the user with their math questions.",
    //     temperature: 0.7,
    //     top_p: 0.9,
    //     max_prompt_tokens: 400,
    //     max_completion_tokens: 200
    // };

    // RunObject resp = check openAIAssistant->/threads/runs.post(createThreadAndRunReq, headers);
    // io:println("Created Thread and Run: ", resp);
    // test:assertNotEquals(resp.id, "", msg = "Thread and Run creation failed: No Run ID returned");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testCreateThread() returns error? {
    CreateThreadRequest createThreadReq = {
        messages: []
    };

    ThreadObject response = check openAIAssistant->/threads.post(createThreadReq, headers);
    io:println("Thread ID: ", response.id);
    threadId = response.id;
    test:assertNotEquals(response.id, "");
}

@test:Config {
    dependsOn: [testCreateAssistant, testGetAssistant, testCreateRun, testGetRunStep, testGetRun, testListRunSteps],
    groups: ["live_tests", "mock_tests"]
}
function testDeleteAssistant() returns error? {
    if (assistantId == "") {
        test:assertFail(msg = "No assistant ID available. Ensure assistant creation test runs first.");
    }

    DeleteAssistantResponse res = check openAIAssistant->/assistants/[assistantId].delete(headers);
    io:println("Assistant deleted successfully: ", res);
    test:assertTrue(res.deleted == true, msg = "Failed to delete assistant");
}

@test:Config {
    dependsOn: [testCreateAssistant],
    groups: ["live_tests", "mock_tests"]
}
function testGetAssistant() returns error? {
    if (assistantId == "") {
        test:assertFail(msg = "No assistant ID available. Ensure you set assistantId before running this test.");
    }

    AssistantObject res = check openAIAssistant->/assistants/[assistantId].get(headers);
    io:println("Assistant Details: ", res);
    test:assertEquals(res.id, assistantId);
}

@test:Config {
    dependsOn: [testCreateRun],
    groups: ["live_tests", "mock_tests"]
}
function testListRunSteps() returns error? {
    ListRunStepsResponse res = check openAIAssistant->/threads/[threadId]/runs/[runId]/steps.get(headers);
    test:assertTrue(res is ListRunStepsResponse);
    io:println("Steps in Run: ", res.data);
    stepId = res.data.length() > 0 ? res.data[0].id : "";
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testCreateAssistant() returns error? {
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

    AssistantObject res = check openAIAssistant->/assistants.post(request, headers);
    io:println("Assistant ID: ", res.id);
    assistantId = res.id;
    test:assertNotEquals(res.id, "");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testListAssistants() returns error? {

    ListAssistantsQueries query = {
        before: "",
        after: ""
    };

    ListAssistantsResponse res = check openAIAssistant->/assistants.get(headers, query);
    io:println("Assistant List: ", res.data);
    test:assertTrue(res is ListAssistantsResponse);
}

@test:Config {
    dependsOn: [testCreateRun],
    groups: ["live_tests", "mock_tests"]
}
function testGetRunStep() returns error? {
    if stepId == "" {
        test:assertEquals(stepId, "", msg = "No step ID available.");
    }
    else {
        RunStepObject res = check openAIAssistant->/threads/[threadId]/runs/[runId]/steps/[stepId].get(headers);
        io:println("Run Step Details: ", res);
        test:assertEquals(res.id, stepId, msg = "Retrieved step ID does not match the requested ID");
    }
}

@test:Config {
    dependsOn: [testCreateThread, testCreateMessage, testDeleteMessage, testGetThread, testListMessages, testGetRunStep, testGetRun, testListRunSteps, testListRuns],
    groups: ["live_tests", "mock_tests"]
}
function testDeleteThread() returns error? {
    if threadId == "" {
        test:assertFail(msg = "No thread ID available. Ensure thread creation test runs first.");
    }

    DeleteThreadResponse res = check openAIAssistant->/threads/[threadId].delete(headers);
    io:println("Thread deleted successfully: ", res);
    test:assertTrue(res.deleted == true, msg = "Failed to delete thread");
}

@test:Config {
    dependsOn: [testCreateThread],
    groups: ["live_tests", "mock_tests"]
}
function testGetThread() returns error? {
    if threadId == "" {
        test:assertFail(msg = "No thread ID available. Ensure testCreateThread runs first.");
    }

    ThreadObject res = check openAIAssistant->/threads/[threadId].get(headers);
    io:println("Thread Details: ", res);
    test:assertEquals(res.id, threadId);
}

@test:Config {
    dependsOn: [testCreateRun],
    groups: ["live_tests", "mock_tests"]
}
function testGetRun() returns error? {
    RunObject res = check openAIAssistant->/threads/[threadId]/runs/[runId].get(headers);
    io:println("Run Details: ", res);
    test:assertEquals(res.id, runId, msg = "Retrieved run ID does not match the requested ID");
}
