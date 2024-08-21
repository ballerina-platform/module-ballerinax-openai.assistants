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
import ballerina/lang.runtime;
import ballerinax/openai.assistants;

// Define configuration and client setup
configurable string token = ?;

final map<string|string[]> headers = {
    "OpenAI-Beta": ["assistants=v2"]
};

public function main() returns error? {
    // Define the client to interact with the OpenAI Assistants API
    final assistants:Client openaiAssistant = check new ({
        auth: {
            token
        }
    });
    // Step 1: Create a new Math Assistant
    assistants:AssistantToolsCode codeTool = {
        'type: "code_interpreter"
    };

    assistants:CreateAssistantRequest request = {
        model: "gpt-3.5-turbo",
        name: "MathTutorBot",
        description: "An Assistant to help with solving math problems",
        instructions: "You are a math tutor bot. Assist users by solving math problems, explaining concepts, and providing step-by-step solutions.",
        tools: [codeTool]
    };

    assistants:AssistantObject assistant = check openaiAssistant->/assistants.post(request, headers);
    io:println("Assistant ID: ", assistant.id);

    // Step 2: Create a new conversation thread
    assistants:CreateThreadRequest threadRequest = {
        messages: []
    };

    assistants:ThreadObject thread = check openaiAssistant->/threads.post(threadRequest, headers);
    io:println("Thread ID: ", thread.id);

    // Step 3: Create a message from the user asking for help with a math problem
    assistants:CreateMessageRequest createMsgReq = {
        role: "user",
        content: "Can you help me solve this equation: 2x + 3 = 7?"
    };

    assistants:MessageObject message = check openaiAssistant->/threads/[thread.id]/messages.post(createMsgReq, headers);
    io:println("User's Message ID: ", message.id);

    // Step 4: Start a run with the math assistant to respond to the query
    assistants:CreateRunRequest runReq = {
        assistant_id: assistant.id,
        model: "gpt-3.5-turbo",
        instructions: "You are a math tutor bot. Assist the user with their math problem.",
        temperature: 0.4,
        max_prompt_tokens: 400, // change as required
        max_completion_tokens: 200
    };

    assistants:RunObject run = check openaiAssistant->/threads/[thread.id]/runs.post(runReq, headers);
    io:println("Run ID: ", run.id);

    // Step 5: Wait for a while to allow the assistant to process the request
    io:println("Waiting for the assistant to process the request...");

    decimal waitTime = 60;
    check waitUntilRunCompletes(openaiAssistant, thread.id, run.id, waitTime);

    // Step 6: Retrieve and display the response from the assistant
    assistants:ListMessagesResponse messages = check openaiAssistant->/threads/[thread.id]/messages.get(headers);

    if messages.data.length() > 0 {
        // Find the assistant's response in the thread
        (assistants:MessageContentImageFileObject|assistants:MessageContentImageUrlObject|assistants:MessageContentTextObject)[] assistantResponse = [];
        foreach assistants:MessageObject threadMessage in messages.data {
            if threadMessage.role == "assistant" {
                assistantResponse = threadMessage.content;
                break;
            }
        }

        foreach (assistants:MessageContentImageFileObject|assistants:MessageContentImageUrlObject|assistants:MessageContentTextObject) responseObject in assistantResponse {
            if responseObject is assistants:MessageContentImageFileObject {
                io:println("Image File ID: ", responseObject.image_file.file_id);
            } else if responseObject is assistants:MessageContentTextObject {
                io:println("Text Response: ", responseObject.text.value);
            } else if responseObject is assistants:MessageContentImageUrlObject {
                io:println("Image URL: ", responseObject.image_url);
            }
        }
    } else {
        io:println("No messages found in the thread.");
    }

    // Step 7: Clean up by deleting the assistant and thread
    assistants:DeleteAssistantResponse delAssistant = check openaiAssistant->/assistants/[assistant.id].delete(headers);
    io:println("Deleted Assistant: ", delAssistant.deleted);

    assistants:DeleteThreadResponse delThread = check openaiAssistant->/threads/[thread.id].delete(headers);
    io:println("Deleted Thread: ", delThread.deleted);
}

# Wait until the run completes or the maximum wait time is reached.
#
# + openaiAssistant - parameter description  
# + threadId - parameter description  
# + runId - parameter description  
# + maxWaitTimeSeconds - parameter description
# + return - return value description
public function waitUntilRunCompletes(assistants:Client openaiAssistant, string threadId, string runId, decimal maxWaitTimeSeconds) returns error? {
    decimal waitedTime = 0;
    decimal pollInterval = 5; // Time in seconds between each poll

    // List of stopping statuses
    final string[] stoppingStatuses = [
        "requires_action",
        "cancelling",
        "cancelled",
        "failed",
        "expired"
    ];

    while (waitedTime < maxWaitTimeSeconds) {
        // Get the current status of the run
        assistants:RunObject run = check openaiAssistant->/threads/[threadId]/runs/[runId].get(headers);
        io:println("Current run status: ", run.status);

        // Check if the run status is in the stopping statuses
        if run.status == "completed" {
            io:println("Run has completed successfully.");
            return;
        }
        else if stoppingStatuses.indexOf(run.status) != () {
            io:println("Run has stopped with status: ", run.status);
            return;
        }

        // Wait for the poll interval before checking again
        runtime:sleep(pollInterval);
        waitedTime += pollInterval;
    }
    return;
}
