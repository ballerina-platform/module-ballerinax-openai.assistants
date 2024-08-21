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

configurable string token = ?;

public function main() returns error? {
    // Define the client to interact with the OpenAI Assistants API
    final assistants:Client openaiAssistant = check new ({
        auth: {
            token
        }
    });
    // Step 1: Create the weather assistant
    assistants:FunctionObject getTemperature = {
        name: "get_temperature",
        description: "Get the current temperature for a specific location",
        parameters: {
            "type": "object",
            "properties": {
                "location": {
                    "type": "string",
                    "description": "The city and state, e.g., San Francisco, CA"
                },
                "unit": {
                    "type": "string",
                    "enum": ["Celsius", "Fahrenheit"],
                    "description": "The temperature unit to use."
                }
            },
            "required": ["location", "unit"]
        }
    };

    assistants:FunctionObject getRainProbability = {
        name: "get_rain_probability",
        description: "Get the probability of rain for a specific location",
        parameters: {
            "type": "object",
            "properties": {
                "location": {
                    "type": "string",
                    "description": "The city and state, e.g., San Francisco, CA"
                }
            },
            "required": ["location"]
        }
    };

    assistants:AssistantToolsFunction getTemperatureTool = {
        "type": "function",
        "function": getTemperature
    };

    assistants:AssistantToolsFunction getRainProbabilityTool = {
        "type": "function",
        "function": getRainProbability
    };

    assistants:CreateAssistantRequest assistantRequest = {
        name: "Weather Assistant",
        description: "An assistant to provide weather information using function calls.",
        model: "gpt-3.5-turbo",
        instructions: "You are a weather bot. Use the provided functions to answer questions.Only use the provided functions(get_temperature, get_rain_probability) to answer",
        tools: [
            getTemperatureTool,
            getRainProbabilityTool
        ]
    };

    assistants:CreateAssistantHeaders createAssistantHeaders = {
        OpenAI-Beta: "assistants=v2"
    };

    // Create the assistant
    assistants:AssistantObject response = check openaiAssistant->/assistants.post(createAssistantHeaders,assistantRequest);
    io:println("Assistant created successfully with ID: " + response.id);
    string assistantId = response.id;

    // Step 2: Create a thread and add a message
    string threadId = "";
    assistants:CreateThreadRequest request = {};

    assistants:CreateThreadHeaders createThreadHeaders = {
        OpenAI-Beta: "assistants=v2"
    };

    assistants:ThreadObject threadResponse = check openaiAssistant->/threads.post(createThreadHeaders, request);
    io:println("Thread created successfully with ID: " + threadResponse.id);

    threadId = threadResponse.id;

    assistants:CreateMessageRequest messageRequest = {
        role: "user",
        content: "What's the weather in San Francisco today and the likelihood it'll rain?"
    };

    assistants:CreateMessageHeaders createMessageHeaders = {
        OpenAI-Beta: "assistants=v2"
    };

    assistants:MessageObject messageResponse = check openaiAssistant->/threads/[threadId]/messages.post(createMessageHeaders, messageRequest);
    io:println("Message created successfully with ID: " + messageResponse.id);

    // Step 3: Initiate the run and handle function calls
    assistants:CreateRunRequest runRequest = {
        assistant_id: assistantId,
        model: "gpt-3.5-turbo",
        instructions: "You are a weather bot. Use the provided functions(get_temperature, get_rain_probability) to answer questions.",
        temperature: 0.4,
        max_prompt_tokens: 400,
        max_completion_tokens: 200,
        tool_choice: "required"
    };

    assistants:CreateRunHeaders createRunHeaders = {
        OpenAI-Beta: "assistants=v2"
    };

    assistants:RunObject runResponse = check openaiAssistant->/threads/[threadId]/runs.post(createRunHeaders, runRequest);
    string runId = runResponse.id;

    check waitUntilRunCompletes(openaiAssistant, threadId, runId, 60);
    runResponse = check openaiAssistant->/threads/[threadId]/runs/[runId].get(headers);
    // Step 4: Submit required tool outputs
    if runResponse.status == "requires_action" && runResponse.required_action is assistants:RunObject_required_action {
        assistants:SubmitToolOutputsRunRequest_tool_outputs[] toolOutputs = [];
        assistants:RunObject_required_action_submit_tool_outputs? requiredActionSubmit = runResponse.required_action?.submit_tool_outputs;
        if requiredActionSubmit is () {
            io:println("No required tool calls found.");
        } else {
            // Iterate over the required tool calls
            foreach assistants:RunToolCallObject toolCall in requiredActionSubmit.tool_calls {
                io:println("Processing tool call: ", toolCall.'function.name);

                if toolCall.'function.name == "get_temperature" {
                    // Simulate the function output
                    toolOutputs.push({
                        tool_call_id: toolCall.id,
                        output: "20" // Simulated temperature
                    });
                } else if toolCall.'function.name == "get_rain_probability" {
                    // Simulate the function output
                    toolOutputs.push({
                        tool_call_id: toolCall.id,
                        output: "0.3" // Simulated rain probability
                    });
                }
            }

            // Check if any toolOutputs are empty
            if toolOutputs.length() == 0 {
                io:println("No tool outputs generated. This might indicate an issue with tool call processing.");
            }
        }

        assistants:SubmitToolOutputsRunRequest submissionRequest = {
            tool_outputs: toolOutputs
        };
        // Submit tool outputs
        assistants:RunObject submissionResponse = check openaiAssistant->/threads/[threadId]/runs/[runId]/submit_tool_outputs.post(submissionRequest, headers);

        io:println("Tool outputs submitted successfully.");
        check waitUntilRunCompletes(openaiAssistant, threadId, runId, 60);
        io:println("Run completed with status: " + submissionResponse.status);
    } else {
        io:println("Run completed without requiring action.");
    }

    // Step 5: Retrieve and display the response from the assistant
    assistants:ListMessagesResponse messages = check openaiAssistant->/threads/[threadId]/messages.get(headers);

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

    // Step 6: Clean up by deleting the assistant and thread
    assistants:DeleteAssistantResponse delAssistant = check openaiAssistant->/assistants/[assistantId].delete(headers);
    io:println("Deleted Assistant: ", delAssistant.deleted);

    assistants:DeleteThreadResponse delThread = check openaiAssistant->/threads/[threadId].delete(headers);
    io:println("Deleted Thread: ", delThread.deleted);
}

# Function to wait until the run completes or the maximum wait time is reached
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
