## Overview

OpenAI is an American artificial intelligence research organization that comprises both a non-profit and a for-profit entity. The organization focuses on conducting cutting-edge AI research with the goal of developing friendly AI that benefits humanity. By advancing the state of AI, OpenAI aims to ensure that powerful AI technologies are used responsibly and ethically, promoting innovation while addressing potential risks.

The `ballarinax/openai.Assistants` connector allows developers to seamlessly integrate OpenAI's advanced language models into their applications by interacting with [OpenAI REST API v1](https://platform.openai.com/docs/api-reference/assistants). This connector provides tools to build powerful [OpenAI Assistants](https://platform.openai.com/docs/assistants/overview) capable of performing a wide range of tasks, such as generating human-like text, managing conversations with persistent threads, and utilizing multiple tools in parallel. OpenAI has recently announced a variety of new features and improvements to the Assistants API, moving their Beta to a [new API version](https://platform.openai.com/docs/assistants/whats-new), `OpenAI-Beta: assistants=v2`. The users can interact with both the API v1 and v2 by [passing the respective API version header in the request](https://platform.openai.com/docs/assistants/migration/changing-beta-versions)  


## Setup guide

To use the OpenAI Connector, you must have access to the OpenAI API through a [OpenAI Platform account](https://platform.openai.com) and a project under it. If you do not have a OpenAI Platform account, you can sign up for one [here](https://platform.openai.com/signup).

#### Create a OpenAI API Key

1. Open the [OpenAI Platform Dashboard](https://platform.openai.com).


2. Navigate to Dashboard -> API keys
<img src=https://github.com/user-attachments/assets/b2e09c6d-c15f-4cfa-a596-6328b1383162 alt="OpenAI Platform" style="width: 70%;">


3. Click on the "Create new secret key" button
<img src=https://github.com/user-attachments/assets/bf1adab4-5e3f-4094-9a56-5b4c3cc3c19e alt="OpenAI Platform" style="width: 70%;">


4. Fill the details and click on Create secret key
<img src=https://github.com/user-attachments/assets/1c565923-e968-4d5f-9864-7ed2022b8079 alt="OpenAI Platform" style="width: 70%;">


5. Store the API key securely to use in your application 
<img src=https://github.com/user-attachments/assets/bbbf8f38-d551-40ee-9664-f4cf2bd98997 alt="OpenAI Platform" style="width: 70%;">

## Quickstart

To use the `OpenAI Assistants` connector in your Ballerina application, update the `.bal` file as follows:
### Step 1: Import the module

Import the `openai.assistants` module.

```ballerina
import ballerinax/openai.assistants;
```

### Step 2: Instantiate a new connector

Create a `assistants:ConnectionConfig` with the obtained access token and initialize the connector with it.

```ballerina
configurable string token = ?;

final assistants:Client openAIAssistant = check new ({
    auth: {
        token
    }
});
```

#### Setting HTTP Headers in Ballerina

Calls to the Assistants API require that you pass a beta HTTP header. In Ballerina, you can define the header as follows:

```ballerina
final map<string|string[]> headers = {
    "OpenAI-Beta": ["assistants=v2"]
};
```

### Step 3: Invoke the connector operations

Now, utilize the available connector operations.


```ballerina
public function main() returns error? {

    // define the required tool
    assistants:AssistantToolsCode tool = {
        type: "code_interpreter"
    };

    // define the assistant request object
    assistants:CreateAssistantRequest request = {
        model: "gpt-3.5-turbo",
        name: "Math Tutor",
        description: "An Assistant for personal math tutoring",
        instructions: "You are a personal math tutor. Help the user with their math questions.",
        tools: [tool]
    };

    // call the `post assistants` resource to create an Assistant
    assistants:AssistantObject assistantResponse = check openAIAssistant->/assistants.post(request, headers);
}
```

### Step 4: Run the Ballerina application

```bash
bal run
```

## Examples

The `OpenAI Assistants` connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/module-ballerinax-openai-assistants/tree/main/examples/), covering the following use cases:

1. [Math tutor bot](https://github.com/ballerina-platform/module-ballerinax-openai.assistants/tree/main/examples/Math-tutor-bot) - Create an assistant to solve mathematical problems with step-by-step solutions and interactive guidance.

2. [Weather assistant](https://github.com/ballerina-platform/module-ballerinax-openai.assistants/tree/main/examples/Weather-assistant) - Develop an assistant to provide weather information by leveraging function calls for temperature and rain probability.
