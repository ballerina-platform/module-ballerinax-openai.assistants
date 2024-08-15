## Math Assistant

This Ballerina example demonstrates how to create a Math Tutor Bot using the OpenAI Assistants API. The bot is designed to assist users with solving mathematical problems by providing step-by-step solutions, explanations, and interactive guidance. The example covers the complete workflow: creating the assistant, starting a conversation, sending a math problem as a message, initiating a run to process the problem, and finally retrieving the bot's response. The loop ensures the system waits until the bot completes the task or a timeout occurs, making it ideal for scenarios where real-time interaction and problem-solving are required.

## Prerequisites

### 1. Generate a API key

Refer to the [Setup guide](https://central.ballerina.io/ballerinax/openai.finetunes/latest#setup-guide) to obtain the API key.

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