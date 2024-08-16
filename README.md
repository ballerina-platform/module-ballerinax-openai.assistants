# Ballerina OpenAI Assistants connector

[![Build](https://github.com/ballerina-platform/module-ballerinax-openai.assistants/actions/workflows/ci.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-openai.assistants/actions/workflows/ci.yml)
[![Trivy](https://github.com/ballerina-platform/module-ballerinax-openai.assistants/actions/workflows/trivy-scan.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-openai.assistants/actions/workflows/trivy-scan.yml)
[![GraalVM Check](https://github.com/ballerina-platform/module-ballerinax-openai.assistants/actions/workflows/build-with-bal-test-native.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-openai.assistants/actions/workflows/build-with-bal-test-native.yml)
[![GitHub Last Commit](https://img.shields.io/github/last-commit/ballerina-platform/module-ballerinax-openai.assistants.svg)](https://github.com/ballerina-platform/module-ballerinax-openai.assistants/commits/master)
[![GitHub Issues](https://img.shields.io/github/issues/ballerina-platform/ballerina-library/module/openai.assistants.svg?label=Open%20Issues)](https://github.com/ballerina-platform/ballerina-library/labels/module%openai.assistants)

## Overview

[OpenAI](https://openai.com/), an AI research organization focused on creating friendly AI for humanity, offers the [OpenAI API](https://platform.openai.com/docs/api-reference/introduction) to access its powerful AI models for tasks like natural language processing and image generation.

The `ballarinax/openai.Assistants` connector allows developers to seamlessly integrate OpenAI's advanced language models into their applications by interacting with [OpenAI REST API v1](https://platform.openai.com/docs/api-reference/assistants). This connector provides tools to build powerful [OpenAI Assistants](https://platform.openai.com/docs/assistants/overview) capable of performing a wide range of tasks, such as generating human-like text, managing conversations with persistent threads, and utilizing multiple tools in parallel. OpenAI has recently announced a variety of new features and improvements to the Assistants API, moving their Beta to a [new API version](https://platform.openai.com/docs/assistants/whats-new), `OpenAI-Beta: assistants=v2`. The users can interact with both the API v1 and v2 by [passing the respective API version header with the request.](https://platform.openai.com/docs/assistants/migration/changing-beta-versions)


## Setup guide

To use the OpenAI Connector, you must have access to the OpenAI API through a [OpenAI Platform account](https://platform.openai.com) and a project under it. If you do not have a OpenAI Platform account, you can sign up for one [here](https://platform.openai.com/signup).


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