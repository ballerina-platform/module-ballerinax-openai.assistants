## Weather Assistant

This example demonstrates how the OpenAI Assistants API `OpenAI-Beta: assistants=v2` can be used to create a Weather Assistant capable of providing weather information such as temperature and rain probability. The example covers the complete workflow: creating the assistant, defining the functions for retrieving temperature and rain probability, starting a conversation, sending a weather-related query, initiating a run to process the query, and finally handling the assistant's function calls. The approach ensures that the assistant responds with accurate weather details, making it suitable for real-time weather inquiries and forecasting scenarios.

## Prerequisites

### 1. Generate an API key

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