## Math tutor bot
This use case demonstrates how the OpenAI Assistants API `OpenAI-Beta: assistants=v2` can be utilized to create a Math Tutor Bot using Ballerina. The example showcases a series of steps that involve creating an assistant designed to help users with mathematical problems. This includes defining functions for solving and explaining math problems, starting a conversation, sending a math problem as a message, initiating a run to process the problem, and retrieving the assistant's step-by-step response. The example highlights the integration of function calls and real-time interaction to provide accurate and detailed solutions for various mathematical queries.

## Prerequisites

### 1. Generate a API key

Refer to the [Setup guide](https://central.ballerina.io/ballerinax/openai.assistants/latest#setup-guide) to obtain the API key.

### 2. Configuration

Create a `Config.toml` file in the example's root directory as follows:

```bash
token = "<API key>"
```

## Run the example

Execute the following command to run the example:

```bash
bal run
```