# Ballerina OpenAI Assistants connector

[![Build](https://github.com/ballerina-platform/module-ballerinax-openai.assistants/actions/workflows/ci.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-openai.assistants/actions/workflows/ci.yml)
[![Trivy](https://github.com/ballerina-platform/module-ballerinax-openai.assistants/actions/workflows/trivy-scan.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-openai.assistants/actions/workflows/trivy-scan.yml)
[![GraalVM Check](https://github.com/ballerina-platform/module-ballerinax-openai.assistants/actions/workflows/build-with-bal-test-native.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-openai.assistants/actions/workflows/build-with-bal-test-native.yml)
[![GitHub Last Commit](https://img.shields.io/github/last-commit/ballerina-platform/module-ballerinax-openai.assistants.svg)](https://github.com/ballerina-platform/module-ballerinax-openai.assistants/commits/master)
[![GitHub Issues](https://img.shields.io/github/issues/ballerina-platform/ballerina-library/module/openai.assistants.svg?label=Open%20Issues)](https://github.com/ballerina-platform/ballerina-library/labels/module%openai.assistants)

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

A typical integration of the Assistants API has the following flow:

1. **Create an Assistant**
    - Define its custom instructions and pick a model.
    - If helpful, add files and enable tools like Code Interpreter, File Search, and Function calling.

2. **Create a Thread**
    - Create a Thread when a user starts a conversation.

3. **Add Messages to the Thread**
    - Add Messages to the Thread as the user asks questions.

4. **Run the Assistant**
    - Run the Assistant on the Thread to generate a response by calling the model and the tools.

This starter guide walks through the key steps to create and run an Assistant that uses the Code Interpreter tool. In this example, we're creating an Assistant that is a personal math tutor.
### Setting HTTP Headers in Ballerina

Calls to the Assistants API require that you pass a beta HTTP header. In Ballerina, you can define the header as follows:

```ballerina
final map<string|string[]> headers = {
    "OpenAI-Beta": ["assistants=v2"]
};
```

### Step 1 : Setting up the connector
To use the `OpenAI Assistants` connector in your Ballerina application, update the `.bal` file as follows:

1. Import the `openai.assistants` module.

```ballerina
import ballerinax/openai.assistants;
```

2. Create a `assistants:ConnectionConfig` with the obtained access token and initialize the connector with it.

```ballerina
configurable string token = ?;

final assistants:Client openAIAssistant = check new({
    auth: {
        token
    }
});
```

### Step 2: Create an Assistant

Now, utilize the available connector operations to create an Assistant.



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

### Step 3: Create a thread

A Thread represents a conversation between a user and one or many Assistants. You can create a Thread when a user (or your AI application) starts a conversation with your Assistant.

```ballerina
public function main() returns error?{
    // define the thread request 
    assistants:CreateThreadRequest createThreadReq = {
        messages: []
    };

    // call the `post threads` resource to create a Thread
    assistants:ThreadObject threadResponse = check openAIAssistant->/threads.post(createThreadReq, headers);
}
```

### Step 4: Add a message to the thread

The contents of the messages your users or applications create are added as Message objects to the Thread. Messages can contain both text and files. There is no limit to the number of Messages you can add to Threads — the context that does not fit into the model's context window will be truncated automatically.

```ballerina
public function main() returns error?{
    string threadId = "your_thread_id";

    // define the message object
    assistants:CreateMessageRequest createMsgReq = {
        role: "user",
        content: "Can you help me solve the equation `3x + 11 = 14`?",
        metadata: {}
    };

    // create a message in the thread
    assistants:MessageObject messageResponse = check openAIAssistant->/threads/[threadId]/messages.post(createMsgReq, headers);
}
```


### Step 5: Create a run

Once all the user Messages have been added to the Thread, you can Run the Thread with any Assistant. Creating a Run uses the model and tools associated with the Assistant to generate a response. These responses are added to the Thread as Assistant Messages.

```ballerina
public function main() returns error?{
    string threadId = "your_thread_id";

    // define the run request object
    assistants:CreateRunRequest runReq = {
        assistant_id: "your_assistant_id",
        model: "gpt-3.5-turbo",
        instructions: "You are a personal math tutor. Assist the user with their math questions.",
        temperature: 0.7,
        top_p: 0.9,
        max_prompt_tokens: 400,
        max_completion_tokens: 200
    };

    // create a run in the thread
    assistants:RunObject runResponse = check openAIAssistant->/threads/[threadId]/runs.post(runReq, headers);

}
```
Once the Run completes, you can list the Messages added to the Thread by the Assistant.

```ballerina
public function main() returns error?{
    string threadId = "your_thread_id";

    // list messages in the thread
    assistants:ListMessagesResponse listResponse = openAIAssistant->/threads/[threadId]/messages.get(headers);
}
```

## Examples

The `OpenAI Assistants` connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/module-ballerinax-openai.assistants/tree/main/examples/), covering the following use cases:

[//]: # (TODO: Add examples)

## Build from the source

### Setting up the prerequisites

1. Download and install Java SE Development Kit (JDK) version 17. You can download it from either of the following sources:

    * [Oracle JDK](https://www.oracle.com/java/technologies/downloads/)
    * [OpenJDK](https://adoptium.net/)

   > **Note:** After installation, remember to set the `JAVA_HOME` environment variable to the directory where JDK was installed.

2. Download and install [Ballerina Swan Lake](https://ballerina.io/).

3. Download and install [Docker](https://www.docker.com/get-started).

   > **Note**: Ensure that the Docker daemon is running before executing any tests.

4. Export Github Personal access token with read package permissions as follows,

    ```bash
    export packageUser=<Username>
    export packagePAT=<Personal access token>
    ```

### Build options

Execute the commands below to build from the source.

1. To build the package:

   ```bash
   ./gradlew clean build
   ```

2. To run the tests:

   ```bash
   ./gradlew clean test
   ```

3. To build the without the tests:

   ```bash
   ./gradlew clean build -x test
   ```

4. To run tests against different environments:

   ```bash
   ./gradlew clean test -Pgroups=<Comma separated groups/test cases>
   ```

5. To debug the package with a remote debugger:

   ```bash
   ./gradlew clean build -Pdebug=<port>
   ```

6. To debug with the Ballerina language:

   ```bash
   ./gradlew clean build -PbalJavaDebug=<port>
   ```

7. Publish the generated artifacts to the local Ballerina Central repository:

    ```bash
    ./gradlew clean build -PpublishToLocalCentral=true
    ```

8. Publish the generated artifacts to the Ballerina Central repository:

   ```bash
   ./gradlew clean build -PpublishToCentral=true
   ```

## Contribute to Ballerina

As an open-source project, Ballerina welcomes contributions from the community.

For more information, go to the [contribution guidelines](https://github.com/ballerina-platform/ballerina-lang/blob/master/CONTRIBUTING.md).

## Code of conduct

All the contributors are encouraged to read the [Ballerina Code of Conduct](https://ballerina.io/code-of-conduct).

## Useful links

* For more information go to the [`openai.assistants` package](https://central.ballerina.io/ballerinax/openai.assistants/latest).
* For example demonstrations of the usage, go to [Ballerina By Examples](https://ballerina.io/learn/by-example/).
* Chat live with us via our [Discord server](https://discord.gg/ballerinalang).
* Post all technical questions on Stack Overflow with the [#ballerina](https://stackoverflow.com/questions/tagged/ballerina) tag.