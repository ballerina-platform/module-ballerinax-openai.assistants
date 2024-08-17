# Examples

The `ballerinax/openai.assistants` connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/ballerina-platform/module-ballerinax-openai.assistants/tree/main/examples), covering use cases like cache management, session management, and rate limiting.

1. [Math Tutor Bot](https://github.com/ballerina-platform/module-ballerinax-openai.assistants/tree/main/examples/Math-tutor-bot) - Create an assistant to solve mathematical problems with step-by-step solutions and interactive guidance.

2. [Weather Assistant](https://github.com/ballerina-platform/module-ballerinax-openai.assistants/tree/main/examples/Weather-assistant) - Develop an assistant to provide weather information by leveraging function calls for temperature and rain probability.

## Prerequisites

1. Generate an API key as described in the [Setup guide](https://central.ballerina.io/ballerinax/openai.finetunes/latest#setup-guide).

2. For each example, create a `Config.toml` file the related configuration. Here's an example of how your `Config.toml` file should look:

    ```toml
    token = "<API Key>"
    ```

## Running an Example

Execute the following commands to build an example from the source:

* To build an example:

    ```bash
    bal build
    ```

* To run an example:

    ```bash
    bal run
    ```

## Building the Examples with the Local Module

**Warning**: Due to the absence of support for reading local repositories for single Ballerina files, the Bala of the module is manually written to the central repository as a workaround. Consequently, the bash script may modify your local Ballerina repositories.

Execute the following commands to build all the examples against the changes you have made to the module locally:

* To build all the examples:

    ```bash
    ./build.sh build
    ```

* To run all the examples:

    ```bash
    ./build.sh run
    ```