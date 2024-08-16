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

import ballerina/http;
import ballerina/log;

listener http:Listener httpListener = new (9090);

# Description.
#
# + body - field description  
# + headers - field description
public type OkMessageObject record {|
    *http:Ok;
    MessageObject body;
    map<string|string[]> headers;
|};

# Description.
#
# + body - field description  
# + headers - field description
public type OkRunObject record {|
    *http:Ok;
    RunObject body;
    map<string|string[]> headers;
|};

# Description.
#
# + body - field description  
# + headers - field description
public type OkAssistantObject record {|
    *http:Ok;
    AssistantObject body;
    map<string|string[]> headers;
|};

# Description.
#
# + body - field description  
# + headers - field description
public type OkThreadObject record {|
    *http:Ok;
    ThreadObject body;
    map<string|string[]> headers;
|};

http:Service mockService = service object {
    # Delete an assistant.
    #
    # + assistant_id - The ID of the assistant to delete.
    # + return - OK 
    resource function delete assistants/[string assistant_id]() returns DeleteAssistantResponse {
        DeleteAssistantResponse response = {
            "id": "asst_ZDxAT9DQaMD6WACtW1Ap67zE",
            "object": "assistant.deleted",
            "deleted": true
        };
        return response;
    }

    # Delete a thread.
    #
    # + thread_id - The ID of the thread to delete.
    # + return - OK 
    resource function delete threads/[string thread_id]() returns DeleteThreadResponse {
        DeleteThreadResponse response = {
            "id": "thread_Aui7BIKeelraAZvX7jc6PoLn",
            "object": "thread.deleted",
            "deleted": true
        };
        return response;
    }

    # Deletes a message.
    #
    # + thread_id - The ID of the thread to which this message belongs.
    # + message_id - The ID of the message to delete.
    # + return - OK 
    resource function delete threads/[string thread_id]/messages/[string message_id]() returns DeleteMessageResponse {
        DeleteMessageResponse response = {
            "id": "msg_dNdBUSpsQt6bqCWjxi2O7RRo",
            "object": "thread.message.deleted",
            "deleted": true
        };
        return response;
    }

    # Returns a list of assistants.
    #
    # + 'limit - A limit on the number of objects to be returned. Limit can range between 1 and 100, and the default is 20.
    # + 'order - Sort order by the `created_at` timestamp of the objects. `asc` for ascending order and `desc` for descending order.
    # + after - A cursor for use in pagination. `after` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, ending with obj_foo, your subsequent call can include after=obj_foo in order to fetch the next page of the list.
    # + before - A cursor for use in pagination. `before` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, ending with obj_foo, your subsequent call can include before=obj_foo in order to fetch the previous page of the list.
    # + return - OK 
    resource function get assistants(string? after, string? before, int 'limit = 20, "asc"|"desc" 'order = "desc") returns ListAssistantsResponse {
        ListAssistantsResponse response = {
            "object": "list",
            "data": [
                {
                    "id": "asst_WK0UraQJvxINF81knnBogkrW",
                    "object": "assistant",
                    "created_at": 1723093496,
                    "name": "Updated Test Instructor",
                    "description": "This assistant is used to check the update functionality of the connector",
                    "model": "gpt-3.5-turbo",
                    "instructions": "You are a personal math tutor. Help the user with their math questions.",
                    "tools": [
                        {
                            "type": "code_interpreter"
                        }
                    ],
                    "top_p": 1.0,
                    "temperature": 1.0,
                    "tool_resources": {
                        "code_interpreter": {
                            "file_ids": []
                        }
                    },
                    "metadata": {},
                    "response_format": "auto"
                },
                {
                    "id": "asst_7nau3bQVnkGr8RDq4m4k2J8a",
                    "object": "assistant",
                    "created_at": 1723004479,
                    "name": "Math Tutor",
                    "description": "An Assistant for personal math tutoring",
                    "model": "gpt-3.5-turbo",
                    "instructions": "You are a personal math tutor. Help the user with their math questions.",
                    "tools": [
                        {
                            "type": "code_interpreter"
                        }
                    ],
                    "top_p": 1.0,
                    "temperature": 1.0,
                    "tool_resources": {
                        "code_interpreter": {
                            "file_ids": []
                        }
                    },
                    "metadata": {},
                    "response_format": "auto"
                },
                {
                    "id": "asst_V2jlCEVauaQ3mnlMyAnWxNpL",
                    "object": "assistant",
                    "created_at": 1722938084,
                    "name": "Math Tutor",
                    "description": "An Assistant for personal math tutoring",
                    "model": "gpt-3.5-turbo",
                    "instructions": "You are a personal math tutor. Help the user with their math questions.",
                    "tools": [
                        {
                            "type": "code_interpreter"
                        }
                    ],
                    "top_p": 1.0,
                    "temperature": 1.0,
                    "tool_resources": {
                        "code_interpreter": {
                            "file_ids": []
                        }
                    },
                    "metadata": {},
                    "response_format": "auto"
                },
                {
                    "id": "asst_Tbzquqszj74elIBGsO6uh5LM",
                    "object": "assistant",
                    "created_at": 1722592672,
                    "name": "Test instructor",
                    "description": null,
                    "model": "gpt-3.5-turbo",
                    "instructions": null,
                    "tools": [],
                    "top_p": 1.0,
                    "temperature": 1.0,
                    "tool_resources": {},
                    "metadata": {},
                    "response_format": "auto"
                },
                {
                    "id": "asst_ZDxAT9DQaMD6WACtW1Ap67zE",
                    "object": "assistant",
                    "created_at": 1722591500,
                    "name": "Test instructor",
                    "description": null,
                    "model": "gpt-3.5-turbo",
                    "instructions": null,
                    "tools": [],
                    "top_p": 1.0,
                    "temperature": 1.0,
                    "tool_resources": {},
                    "metadata": {},
                    "response_format": "auto"
                },
                {
                    "id": "asst_2898ikQjuZAPp7ywiJJZ41xr",
                    "object": "assistant",
                    "created_at": 1722493712,
                    "name": "Math Tutor",
                    "description": null,
                    "model": "gpt-4o-mini",
                    "instructions": "You are a personal math tutor. When asked a question, write and run Python code to answer the question.",
                    "tools": [
                        {
                            "type": "code_interpreter"
                        }
                    ],
                    "top_p": 1.0,
                    "temperature": 1.0,
                    "tool_resources": {
                        "code_interpreter": {
                            "file_ids": []
                        }
                    },
                    "metadata": {},
                    "response_format": "auto"
                }
            ],
            "first_id": "asst_WK0UraQJvxINF81knnBogkrW",
            "last_id": "asst_2898ikQjuZAPp7ywiJJZ41xr",
            "has_more": false
        };
        return response;
    }

    # Retrieves an assistant.
    #
    # + assistant_id - The ID of the assistant to retrieve.
    # + return - OK 
    resource function get assistants/[string assistant_id]() returns AssistantObject {
        AssistantObject assistant = {
            "id": "asst_WK0UraQJvxINF81knnBogkrW",
            "object": "assistant",
            "created_at": 1723093496,
            "name": "Updated Test Instructor",
            "description": "This assistant is used to check the update functionality of the connector",
            "model": "gpt-3.5-turbo",
            "instructions": "You are a personal math tutor. Help the user with their math questions.",
            "tools": [
                {
                    "type": "code_interpreter"
                }
            ],
            "top_p": 1.0,
            "temperature": 1.0,
            "tool_resources": {
                "code_interpreter": {
                    "file_ids": []
                }
            },
            "metadata": {},
            "response_format": "auto"
        };
        return assistant;
    }

    # Retrieves a thread.
    #
    # + thread_id - The ID of the thread to retrieve.
    # + return - OK 
    resource function get threads/[string thread_id]() returns ThreadObject {
        ThreadObject thread = {
            "id": "thread_Aui7BIKeelraAZvX7jc6PoLn",
            "object": "thread",
            "created_at": 1723096544,
            "metadata": {},
            "tool_resources": {
                "code_interpreter": {
                    "file_ids": []
                }
            }
        };
        return thread;
    }

    # Returns a list of messages for a given thread.
    #
    # + thread_id - The ID of the [thread](/docs/api-reference/threads) the messages belong to.
    # + 'limit - A limit on the number of objects to be returned. Limit can range between 1 and 100, and the default is 20.
    # + 'order - Sort order by the `created_at` timestamp of the objects. `asc` for ascending order and `desc` for descending order.
    # + after - A cursor for use in pagination. `after` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, ending with obj_foo, your subsequent call can include after=obj_foo in order to fetch the next page of the list.
    # + before - A cursor for use in pagination. `before` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, ending with obj_foo, your subsequent call can include before=obj_foo in order to fetch the previous page of the list.
    # + run_id - Filter messages by the run ID that generated them.
    # + return - OK 
    resource function get threads/[string thread_id]/messages(string? after, string? before, string? run_id, int 'limit = 20, "asc"|"desc" 'order = "desc") returns ListMessagesResponse {
        ListMessagesResponse response = {
            "object": "list",
            "data": [
                {
                    "id": "msg_dNdBUSpsQt6bqCWjxi2O7RRo",
                    "object": "thread.message",
                    "created_at": 1723097972,
                    "assistant_id": null,
                    "thread_id": "thread_wvSOSaULwzdE1R83LtKrVggv",
                    "run_id": null,
                    "role": "user",
                    "content": [
                        {
                            "type": "text",
                            "text": {
                                "value": "I want to calculate the following calculation: 345 x 897. Can you help me?",
                                "annotations": []
                            }
                        }
                    ],
                    "attachments": [],
                    "metadata": {}
                },
                {
                    "id": "msg_PBtjbgfLc82Cez4AMm6u72HI",
                    "object": "thread.message",
                    "created_at": 1723097686,
                    "assistant_id": null,
                    "thread_id": "thread_wvSOSaULwzdE1R83LtKrVggv",
                    "run_id": null,
                    "role": "user",
                    "content": [
                        {
                            "type": "text",
                            "text": {
                                "value": "Can you help me solve the equation `3x + 11 = 14`?",
                                "annotations": []
                            }
                        }
                    ],
                    "attachments": [],
                    "metadata": {}
                }
            ],
            "first_id": "msg_dNdBUSpsQt6bqCWjxi2O7RRo",
            "last_id": "msg_PBtjbgfLc82Cez4AMm6u72HI",
            "has_more": false
        };
        return response;
    }

    # Retrieve a message.
    #
    # + thread_id - The ID of the [thread](/docs/api-reference/threads) to which this message belongs.
    # + message_id - The ID of the message to retrieve.
    # + return - OK 
    resource function get threads/[string thread_id]/messages/[string message_id]() returns MessageObject {
        MessageObject message = {
            "id": "msg_PBtjbgfLc82Cez4AMm6u72HI",
            "object": "thread.message",
            "created_at": 1723097686,
            "assistant_id": null,
            "thread_id": "thread_wvSOSaULwzdE1R83LtKrVggv",
            "run_id": null,
            "role": "user",
            "content": [
                {
                    "type": "text",
                    "text": {
                        "value": "Can you help me solve the equation `3x + 11 = 14`?",
                        "annotations": []
                    }
                }
            ],
            "attachments": [],
            "metadata": {}
        };
        return message;
    }

    # Returns a list of runs belonging to a thread.
    #
    # + thread_id - The ID of the thread the run belongs to.
    # + 'limit - A limit on the number of objects to be returned. Limit can range between 1 and 100, and the default is 20.
    # + 'order - Sort order by the `created_at` timestamp of the objects. `asc` for ascending order and `desc` for descending order.
    # + after - A cursor for use in pagination. `after` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, ending with obj_foo, your subsequent call can include after=obj_foo in order to fetch the next page of the list.
    # + before - A cursor for use in pagination. `before` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, ending with obj_foo, your subsequent call can include before=obj_foo in order to fetch the previous page of the list.
    # + return - OK 
    resource function get threads/[string thread_id]/runs(string? after, string? before, int 'limit = 20, "asc"|"desc" 'order = "desc") returns ListRunsResponse {
        ListRunsResponse response = {
            "object": "list",
            "data": [
                {
                    "id": "run_c73jgpUPMts5wIsC2jOwqYyk",
                    "object": "thread.run",
                    "created_at": 1723106642,
                    "assistant_id": "asst_Ng22gylsXXCdAzYuC2GQ6Ax7",
                    "thread_id": "thread_HOkFKIkPk6HpI3ZsQs2bkEvx",
                    "status": "completed",
                    "started_at": 1723106643,
                    "expires_at": null,
                    "cancelled_at": null,
                    "failed_at": null,
                    "completed_at": 1723106643,
                    "required_action": null,
                    "last_error": null,
                    "model": "gpt-3.5-turbo",
                    "instructions": "You are a personal math tutor. Assist the user with their math questions.",
                    "tools": [
                        {
                            "type": "code_interpreter"
                        }
                    ],
                    "tool_resources": {},
                    "metadata": {},
                    "temperature": 0.7,
                    "top_p": 0.9,
                    "max_completion_tokens": 200,
                    "max_prompt_tokens": 400,
                    "truncation_strategy": {
                        "type": "auto",
                        "last_messages": null
                    },
                    "incomplete_details": null,
                    "usage": {
                        "prompt_tokens": 126,
                        "completion_tokens": 13,
                        "total_tokens": 139
                    },
                    "response_format": "auto",
                    "tool_choice": "auto",
                    "parallel_tool_calls": true
                },
                {
                    "id": "run_9exdx8cs6N6zQ56coAf5NQu2",
                    "object": "thread.run",
                    "created_at": 1723099320,
                    "assistant_id": "asst_Ng22gylsXXCdAzYuC2GQ6Ax7",
                    "thread_id": "thread_HOkFKIkPk6HpI3ZsQs2bkEvx",
                    "status": "expired",
                    "started_at": 1723099320,
                    "expires_at": null,
                    "cancelled_at": null,
                    "failed_at": null,
                    "completed_at": 1723099321,
                    "required_action": null,
                    "last_error": null,
                    "model": "gpt-3.5-turbo",
                    "instructions": "You are a personal math tutor. Assist the user with their math questions.",
                    "tools": [
                        {
                            "type": "code_interpreter"
                        }
                    ],
                    "tool_resources": {},
                    "metadata": {},
                    "temperature": 0.7,
                    "top_p": 0.9,
                    "max_completion_tokens": 200,
                    "max_prompt_tokens": 400,
                    "truncation_strategy": {
                        "type": "auto",
                        "last_messages": null
                    },
                    "incomplete_details": null,
                    "usage": {
                        "prompt_tokens": 111,
                        "completion_tokens": 13,
                        "total_tokens": 124
                    },
                    "response_format": "auto",
                    "tool_choice": "auto",
                    "parallel_tool_calls": true
                }
            ],
            "first_id": "run_c73jgpUPMts5wIsC2jOwqYyk",
            "last_id": "run_9exdx8cs6N6zQ56coAf5NQu2",
            "has_more": false
        };
        return response;
    }

    # Retrieves a run.
    #
    # + thread_id - The ID of the [thread](/docs/api-reference/threads) that was run.
    # + run_id - The ID of the run to retrieve.
    # + return - OK 
    resource function get threads/[string thread_id]/runs/[string run_id]() returns RunObject|error {
        RunObject run = {
            "id": "run_c73jgpUPMts5wIsC2jOwqYyk",
            "object": "thread.run",
            "created_at": 1723106642,
            "assistant_id": "asst_Ng22gylsXXCdAzYuC2GQ6Ax7",
            "thread_id": "thread_HOkFKIkPk6HpI3ZsQs2bkEvx",
            "status": "completed",
            "started_at": 1723106643,
            "expires_at": null,
            "cancelled_at": null,
            "failed_at": null,
            "completed_at": 1723106643,
            "required_action": null,
            "last_error": null,
            "model": "gpt-3.5-turbo",
            "instructions": "You are a personal math tutor. Assist the user with their math questions.",
            "tools": [
                {
                    "type": "code_interpreter"
                }
            ],
            "tool_resources": {},
            "metadata": {},
            "temperature": 0.7,
            "top_p": 0.9,
            "max_completion_tokens": 200,
            "max_prompt_tokens": 400,
            "truncation_strategy": {
                "type": "auto",
                "last_messages": null
            },
            "incomplete_details": null,
            "usage": {
                "prompt_tokens": 126,
                "completion_tokens": 13,
                "total_tokens": 139
            },
            "response_format": "auto",
            "tool_choice": "auto",
            "parallel_tool_calls": true
        };
        return run;
    }

    # Returns a list of run steps belonging to a run.
    #
    # + thread_id - The ID of the thread the run and run steps belong to.
    # + run_id - The ID of the run the run steps belong to.
    # + 'limit - A limit on the number of objects to be returned. Limit can range between 1 and 100, and the default is 20.
    # + 'order - Sort order by the `created_at` timestamp of the objects. `asc` for ascending order and `desc` for descending order.
    # + after - A cursor for use in pagination. `after` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, ending with obj_foo, your subsequent call can include after=obj_foo in order to fetch the next page of the list.
    # + before - A cursor for use in pagination. `before` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, ending with obj_foo, your subsequent call can include before=obj_foo in order to fetch the previous page of the list.
    # + return - OK 
    resource function get threads/[string thread_id]/runs/[string run_id]/steps(string? after, string? before, int 'limit = 20, "asc"|"desc" 'order = "desc") returns ListRunStepsResponse {
        ListRunStepsResponse response = {
            "object": "list",
            "data": [
                {
                    "id": "step_VJjXo2AeyYxsprKooW7yCnCF",
                    "object": "thread.run.step",
                    "created_at": 1723106643,
                    "run_id": "run_c73jgpUPMts5wIsC2jOwqYyk",
                    "assistant_id": "asst_Ng22gylsXXCdAzYuC2GQ6Ax7",
                    "thread_id": "thread_HOkFKIkPk6HpI3ZsQs2bkEvx",
                    "type": "message_creation",
                    "status": "completed",
                    "cancelled_at": null,
                    "completed_at": 1723106643,
                    "expires_at": null,
                    "failed_at": null,
                    "last_error": null,
                    "step_details": {
                        "type": "message_creation",
                        "message_creation": {
                            "message_id": "msg_ULerPne48uzAmoy5gQIuz1mB"
                        }
                    },
                    "usage": {
                        "prompt_tokens": 126,
                        "completion_tokens": 13,
                        "total_tokens": 139
                    }
                }
            ],
            "first_id": "step_VJjXo2AeyYxsprKooW7yCnCF",
            "last_id": "step_VJjXo2AeyYxsprKooW7yCnCF",
            "has_more": false
        };
        return response;
    }

    # Retrieves a run step.
    #
    # + thread_id - The ID of the thread to which the run and run step belongs.
    # + run_id - The ID of the run to which the run step belongs.
    # + step_id - The ID of the run step to retrieve.
    # + return - OK 
    resource function get threads/[string thread_id]/runs/[string run_id]/steps/[string step_id]() returns RunStepObject {
        RunStepObject runStep = {
            "id": "step_VJjXo2AeyYxsprKooW7yCnCF",
            "object": "thread.run.step",
            "created_at": 1723106643,
            "run_id": "run_c73jgpUPMts5wIsC2jOwqYyk",
            "assistant_id": "asst_Ng22gylsXXCdAzYuC2GQ6Ax7",
            "thread_id": "thread_HOkFKIkPk6HpI3ZsQs2bkEvx",
            "type": "message_creation",
            "status": "completed",
            "cancelled_at": null,
            "completed_at": 1723106643,
            "expires_at": null,
            "failed_at": null,
            "last_error": null,
            "step_details": {
                "type": "message_creation",
                "message_creation": {
                    "message_id": "msg_ULerPne48uzAmoy5gQIuz1mB"
                }
            },
            "usage": {
                "prompt_tokens": 126,
                "completion_tokens": 13,
                "total_tokens": 139
            }
        };
        return runStep;
    }

    # Create an assistant with a model and instructions.
    #
    # + return - OK 
    resource function post assistants(@http:Payload CreateAssistantRequest payload) returns OkAssistantObject {
        AssistantObject assistant = {
            "id": "asst_WK0UraQJvxINF81knnBogkrW",
            "object": "assistant",
            "created_at": 1723093496,
            "name": "Math Tutor",
            "description": "An Assistant for personal math tutoring",
            "model": "gpt-3.5-turbo",
            "instructions": "You are a personal math tutor. Help the user with their math questions.",
            "tools": [
                {
                    "type": "code_interpreter"
                }
            ],
            "top_p": 1.0,
            "temperature": 1.0,
            "tool_resources": {
                "code_interpreter": {
                    "file_ids": []
                }
            },
            "metadata": {},
            "response_format": "auto"

        };

        OkAssistantObject response = {
            status: new http:StatusOK(),
            body: assistant,
            headers: headers
        };
        return response;
    }

    # Modifies an assistant.
    #
    # + assistant_id - The ID of the assistant to modify.
    # + return - OK 
    resource function post assistants/[string assistant_id](@http:Payload ModifyAssistantRequest payload) returns OkAssistantObject {
        AssistantObject assistant = {
            "id": "asst_WK0UraQJvxINF81knnBogkrW",
            "object": "assistant",
            "created_at": 1723093496,
            "name": "Updated Test Instructor",
            "description": "This assistant is used to check the update functionality of the connector",
            "model": "gpt-3.5-turbo",
            "instructions": "You are a personal math tutor. Help the user with their math questions.",
            "tools": [
                {
                    "type": "code_interpreter"
                }
            ],
            "top_p": 1.0,
            "temperature": 1.0,
            "tool_resources": {
                "code_interpreter": {
                    "file_ids": []
                }
            },
            "metadata": {},
            "response_format": "auto"
        };

        OkAssistantObject response = {
            status: new http:StatusOK(),
            body: assistant,
            headers: headers
        };
        return response;
    }

    # Create a thread.
    #
    # + return - OK 
    resource function post threads(@http:Payload CreateThreadRequest payload) returns OkThreadObject {
        ThreadObject thread = {
            "id": "thread_Aui7BIKeelraAZvX7jc6PoLn",
            "object": "thread",
            "created_at": 1723096544,
            "metadata": {},
            "tool_resources": {}
        };

        OkThreadObject response = {
            status: new http:StatusOK(),
            body: thread,
            headers: headers
        };
        return response;
    }

    # Modifies a thread.
    #
    # + thread_id - The ID of the thread to modify. Only the `metadata` can be modified.
    # + return - OK 
    resource function post threads/[string thread_id](@http:Payload ModifyThreadRequest payload) returns OkThreadObject {
        ThreadObject thread = {
            "id": "thread_Aui7BIKeelraAZvX7jc6PoLn",
            "object": "thread",
            "created_at": 1723096544,
            "metadata": {},
            "tool_resources": {
                "code_interpreter": {
                    "file_ids": []
                }
            }
        };

        OkThreadObject response = {
            status: new http:StatusOK(),
            body: thread,
            headers: headers
        };
        return response;
    }

    # Create a message.
    #
    # + thread_id - The ID of the [thread](/docs/api-reference/threads) to create a message for.
    # + return - OK 
    resource function post threads/[string thread_id]/messages(@http:Payload CreateMessageRequest payload) returns OkMessageObject {
        MessageObject message = {
            "id": "msg_PBtjbgfLc82Cez4AMm6u72HI",
            "object": "thread.message",
            "created_at": 1723097686,
            "assistant_id": null,
            "thread_id": "thread_wvSOSaULwzdE1R83LtKrVggv",
            "run_id": null,
            "role": "user",
            "content": [
                {
                    "type": "text",
                    "text": {
                        "value": "Can you help me solve the equation `3x + 11 = 14`?",
                        "annotations": []
                    }
                }
            ],
            "attachments": [],
            "metadata": {}
        };

        OkMessageObject response = {
            status: new http:StatusOK(),
            body: message,
            headers: headers
        };

        return response;
    }

    # Modifies a message.
    #
    # + thread_id - The ID of the thread to which this message belongs.
    # + message_id - The ID of the message to modify.
    # + return - OK 
    resource function post threads/[string thread_id]/messages/[string message_id](@http:Payload ModifyMessageRequest payload) returns OkMessageObject {
        MessageObject message = {
            "id": "msg_dNdBUSpsQt6bqCWjxi2O7RRo",
            "object": "thread.message",
            "created_at": 1723097972,
            "assistant_id": null,
            "thread_id": "thread_wvSOSaULwzdE1R83LtKrVggv",
            "run_id": null,
            "role": "user",
            "content": [
                {
                    "type": "text",
                    "text": {
                        "value": "I want to calculate the following calculation: 345 x 897. Can you help me?",
                        "annotations": []
                    }
                }
            ],
            "file_ids": [],
            "metadata": {}
        };

        OkMessageObject response = {
            status: new http:StatusOK(),
            body: message,
            headers: headers
        };
        return response;
    }

    # Create a run.
    #
    # + thread_id - The ID of the thread to run.
    # + return - OK 
    resource function post threads/[string thread_id]/runs(@http:Payload CreateRunRequest payload) returns OkRunObject {
        RunObject run = {
            "id": "run_c73jgpUPMts5wIsC2jOwqYyk",
            "object": "thread.run",
            "created_at": 1723099320,
            "assistant_id": "asst_Ng22gylsXXCdAzYuC2GQ6Ax7",
            "thread_id": "thread_HOkFKIkPk6HpI3ZsQs2bkEvx",
            "status": "queued",
            "started_at": null,
            "expires_at": 1723099920,
            "cancelled_at": null,
            "failed_at": null,
            "completed_at": null,
            "required_action": null,
            "last_error": null,
            "model": "gpt-3.5-turbo",
            "instructions": "You are a personal math tutor. Assist the user with their math questions.",
            "tools": [
                {
                    "type": "code_interpreter"
                }
            ],
            "tool_resources": {},
            "metadata": {},
            "temperature": 0.7,
            "top_p": 0.9,
            "max_completion_tokens": 200,
            "max_prompt_tokens": 400,
            "truncation_strategy": {
                "type": "auto",
                "last_messages": null
            },
            "incomplete_details": null,
            "usage": null,
            "response_format": "auto",
            "tool_choice": "auto",
            "parallel_tool_calls": true
        };

        OkRunObject response = {
            status: new http:StatusOK(),
            body: run,
            headers: headers
        };
        return response;
    }

    # Modifies a run.
    #
    # + thread_id - The ID of the [thread](/docs/api-reference/threads) that was run.
    # + run_id - The ID of the run to modify.
    # + return - OK 
    resource function post threads/[string thread_id]/runs/[string run_id](@http:Payload ModifyRunRequest payload) returns OkRunObject {
        RunObject run = {
            "id": "run_c73jgpUPMts5wIsC2jOwqYyk",
            "object": "thread.run",
            "created_at": 1723106642,
            "assistant_id": "asst_Ng22gylsXXCdAzYuC2GQ6Ax7",
            "thread_id": "thread_HOkFKIkPk6HpI3ZsQs2bkEvx",
            "status": "completed",
            "started_at": 1723106643,
            "expires_at": null,
            "cancelled_at": null,
            "failed_at": null,
            "completed_at": 1723106643,
            "required_action": null,
            "last_error": null,
            "model": "gpt-3.5-turbo",
            "instructions": "You are a personal math tutor. Assist the user with their math questions.",
            "tools": [
                {
                    "type": "code_interpreter"
                }
            ],
            "tool_resources": {},
            "metadata": {},
            "temperature": 0.7,
            "top_p": 0.9,
            "max_completion_tokens": 200,
            "max_prompt_tokens": 400,
            "truncation_strategy": {
                "type": "auto",
                "last_messages": null
            },
            "incomplete_details": null,
            "usage": {
                "prompt_tokens": 126,
                "completion_tokens": 13,
                "total_tokens": 139
            },
            "response_format": "auto",
            "tool_choice": "auto",
            "parallel_tool_calls": true
        };

        OkRunObject response = {
            status: new http:StatusOK(),
            body: run,
            headers: headers
        };
        return response;
    }

    // # Cancels a run that is `in_progress`.
    // #
    // # + thread_id - The ID of the thread to which this run belongs.
    // # + run_id - The ID of the run to cancel.
    // # + return - OK 
    // resource function post threads/[string thread_id]/runs/[string run_id]/cancel() returns OkRunObject {
    // }

    // # When a run has the `status: "requires_action"` and `required_action.type` is `submit_tool_outputs`, this endpoint can be used to submit the outputs from the tool calls once they're all completed. All outputs must be submitted in a single request.
    // #
    // # + thread_id - The ID of the [thread](/docs/api-reference/threads) to which this run belongs.
    // # + run_id - The ID of the run that requires the tool output submission.
    // # + return - OK 
    // resource function post threads/[string thread_id]/runs/[string run_id]/submit_tool_outputs(@http:Payload SubmitToolOutputsRunRequest payload) returns OkRunObject {
    // }

    # Create a thread and run it in one request.
    #
    # + return - OK 
    resource function post threads/runs(@http:Payload CreateThreadAndRunRequest payload) returns OkRunObject {
        RunObject run = {
            "id": "run_c73jgpUPMts5wIsC2jOwqYyk",
            "object": "thread.run",
            "created_at": 1723107153,
            "assistant_id": "asst_Ng22gylsXXCdAzYuC2GQ6Ax7",
            "thread_id": "thread_HOkFKIkPk6HpI3ZsQs2bkEvx",
            "status": "queued",
            "started_at": null,
            "expires_at": 1723107753,
            "cancelled_at": null,
            "failed_at": null,
            "completed_at": null,
            "required_action": null,
            "last_error": null,
            "model": "gpt-3.5-turbo",
            "instructions": "You are a personal math tutor. Assist the user with their math questions.",
            "tools": [
                {
                    "type": "code_interpreter"
                }
            ],
            "tool_resources": {},
            "metadata": {},
            "temperature": 0.7,
            "top_p": 0.9,
            "max_completion_tokens": 200,
            "max_prompt_tokens": 400,
            "truncation_strategy": {
                "type": "auto",
                "last_messages": null
            },
            "incomplete_details": null,
            "usage": null,
            "response_format": "auto",
            "tool_choice": "auto",
            "parallel_tool_calls": true
        };

        OkRunObject response = {
            status: new http:StatusOK(),
            body: run,
            headers: headers
        };
        return response;
    }
};

function init() returns error? {
    if isLiveServer {
        log:printInfo("Skipping mock server initialization as the tests are running on live server");
        return;
    }
    log:printInfo("Initiating mock server");
    check httpListener.attach(mockService, "/");
    check httpListener.'start();
};
