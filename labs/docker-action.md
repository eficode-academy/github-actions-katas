# Custom Docker Action

In this hands-on lab you will create a custom Docker action and use it in a workflow.

## Learning Goals

- Understand how to create a custom Docker action
- Learn how to define action `inputs` and `outputs`
- Understand how to create an `action.yml` metadata file
- Understand how to test custom actions in workflows
- Learn how to publish and version custom actions

## Introduction

GitHub Actions allows you to create custom actions to encapsulate reusable functionality. There are three types of actions:

- **Docker container actions** - Runs a container from a local `Dockerfile` or from a public registry. Ideal for specific environments, dependencies, and ensuring consistency with containerization.
- **JavaScript actions** - Runs a JavaScript file directly on the GitHub Actions runner. Good for complex logic, API interactions, and leveraging Node.js libraries.
- **Composite actions** - Combine multiple workflow steps into a single action. This is useful for reusing workflows and encapsulating common tasks.

In this exercise, we'll focus on creating a Docker container action, which provides a consistent and reliable environment for your action code.

## Exercise

### Overview

In this exercise you will:

- Create a Docker-based custom action that greets a person
- Define input and output parameters for the action
- Create the necessary files (action.yml, Dockerfile, entrypoint.sh)
- Test the action in a workflow
- Optional: Publish the action for reuse

### Step by step instructions

#### Create the action script

The first step is to create a script that we will be running within the Docker container.
This could contain a tool that requires complex dependenciex, but to keep it simple, we
will use a simple shell script. The script will take a name as input and will output
the current time in `$GITHUB_OUTPUT`.

1. Create a new directory called `hello-world-docker-action` in the root of your repository.

2. Create an `entrypoint.sh` script inside this directory. This will contain the logic.

3. Print a greeting using the input parameter to the console. GitHub Actions passes inputs to Docker container actions as command line arguments when you specify them in the `args` section of the action.yml file.

4. Now capture the output from the Linux `date` command into a `$time` variable.

5. Add `time=$time` to the file whose path is stored in `$GITHUB_OUTPUT`.

6. Make the script executable and test it locally by running it directly with a test argument.

    <details>
    <summary>Solution</summary>

    ```bash
    #!/bin/bash

    echo "Hello, $1!"
    time=$(date)
    echo "time=$time" >> $GITHUB_OUTPUT
    ```

    To test the script locally:

    ```bash
    cd hello-world-docker-action
    chmod +x entrypoint.sh
    export GITHUB_OUTPUT=/tmp/github_output
    ./entrypoint.sh "World"
    cat $GITHUB_OUTPUT  # Check the output was written
    ```

    > :bulb: We export the `GITHUB_OUTPUT` environment variable locally so the script can write to it during testing.

    </details>

> :bulb: The entrypoint script receives inputs as command line arguments. We use `$GITHUB_OUTPUT` to set output parameters that can be used by other steps in the workflow.

#### Create the Dockerfile

Now that we have a script that does what we want, let us create the Docker container that will
run the tool in a controlled environment. This is a fairly simple `Dockerfile`, so feel
free to copy the contents from the "soltion" section below.

1. In the same directory as before, create a `Dockerfile` that will define the container environment.

2. Copy the following content into the `Dockerfile`. It will ensure that the script
   and its dependencies are available within the container and that the container
   is set to call the script at startup.

    ```dockerfile
    FROM alpine:3.22

    # Install dependencies
    RUN apk --no-cache add bash

    # Copy the entrypoint script
    COPY entrypoint.sh /entrypoint.sh

    # Make the script executable
    RUN chmod +x /entrypoint.sh

    # Set the entrypoint
    ENTRYPOINT ["/entrypoint.sh"]
    ```

3. If you have Docker on your local machine, you can now test the `Dockerfile` by
   building and running the container.

    <details>
    <summary>Solution</summary>

    To test the Dockerfile locally:

    ```bash
    cd hello-world-docker-action
    docker build -t hello-world-action .
    docker run -e GITHUB_OUTPUT=/tmp/github_output hello-world-action "Docker Test"
    ```

    > :bulb: We set the `GITHUB_OUTPUT` environment variable to a temporary file path so the script doesn't fail when writing the output locally.

    </details>

#### Create the action metadata file

With the  `Dockerfile` definition in place, we can add the `action.yml` metadata that makes
this into a GitHub Action.

1. Create an `action.yml` file in the same directory as before.

2. Define the name and description for your action.

3. Add an input parameter called `who-to-greet` that is required and has a default value of `World`.

4. Add an output parameter called `time` that will contain the timestamp from your script.

5. Configure the action to run using Docker with the local `Dockerfile`.

6. Add an `args` section to pass the `who-to-greet` input as a command line argument to your container.

    <details>
    <summary>Solution</summary>

    ```yaml
    name: 'Hello World Docker Action'
    description: 'Greet someone and record the time'
    
    inputs:
      who-to-greet:
        description: 'Who to greet'
        required: true
        default: 'World'
    
    outputs:
      time:
        description: 'The time we greeted you'
    
    runs:
      using: 'docker'
      image: 'Dockerfile'
      args:
        - ${{ inputs.who-to-greet }}
    ```

    </details>

> :bulb: The `action.yml` file defines the interface of your action. It specifies the inputs, outputs, and how the action should be run.

#### Create a workflow to test the action

1. Create a workflow file `.github/workflows/test-docker-action.yml` to test your custom action.

2. Configure the workflow to trigger on pushes that change files in the `hello-world-docker-action` directory.

3. Add a manual trigger (workflow_dispatch) for testing purposes.

4. Create a job that runs on `ubuntu-latest`.

5. Add a step to checkout the repository.

6. Add a step to use your custom action with a specific greeting target.
   - Set an `id` for the step to ensure that it can be referenced later on.
   - Like other GitHub Actions, your custom action will be called with `uses:`.
     Point to the folder containing the action (`./hello-world-docker-action`)
   - Parameters to your action is defined in the `with:` section.

7. Add a step to display the output from your action.

8. Commit all files and push to trigger the workflow.

    <details>
    <summary>Solution</summary>

    ```yaml
    name: Test Custom Action

    on:
      push:
        paths:
          - 'hello-world-docker-action/**'
      workflow_dispatch:

    jobs:
      test-action:
        runs-on: ubuntu-latest
        steps:
          - name: Checkout repository
            uses: actions/checkout@v4
            
          - name: Test custom action
            id: hello
            uses: ./hello-world-docker-action
            with:
              who-to-greet: 'GitHub Actions Student'
              
          - name: Use the output
            run: echo "The time was ${{ steps.hello.outputs.time }}"
    ```

    To commit and test:

    ```bash
    git add .
    git commit -m "Add custom Docker action"
    git push
    ```

    </details>

#### Advanced: Add more functionality

1. **Optional:** Enhance your action by adding more input parameters. Modify the `action.yml` to accept a `greeting-type` input:

    <details>
    <summary>Solution</summary>

    ```yaml
    name: 'Hello World Docker Action'
    description: 'Greet someone and record the time'
    
    inputs:
      who-to-greet:
        description: 'Who to greet'
        required: true
        default: 'World'
      greeting-type:
        description: 'Type of greeting (hello, hi, hey)'
        required: false
        default: 'Hello'
    
    outputs:
      time:
        description: 'The time we greeted you'
      message:
        description: 'The full greeting message'
    
    runs:
      using: 'docker'
      image: 'Dockerfile'
      args:
        - ${{ inputs.greeting-type }}
        - ${{ inputs.who-to-greet }}
    ```

    </details>

2. **Optional:** Update the `entrypoint.sh` script to use the new parameter:

    <details>
    <summary>Solution</summary>

    ```bash
    #!/bin/bash

    greeting_type="$1"
    who_to_greet="$2"

    message="$greeting_type $who_to_greet"
    echo "$message"

    time=$(date)
    echo "time=$time" >> $GITHUB_OUTPUT
    echo "message=$message" >> $GITHUB_OUTPUT
    ```

    </details>

3. **Optional:** Update your workflow to use the new input parameter and display the `message` output:

    <details>
    <summary>Solution</summary>

    ```yaml
    name: Test Custom Action

    on:
      push:
        paths:
          - 'hello-world-docker-action/**'
      workflow_dispatch:

    jobs:
      test-action:
        runs-on: ubuntu-latest
        steps:
          - name: Checkout repository
            uses: actions/checkout@v4
            
          - name: Test custom action
            id: hello
            uses: ./hello-world-docker-action
            with:
              who-to-greet: 'GitHub Actions Student'
              greeting-type: 'Hi'
              
          - name: Use the outputs
            run: |
              echo "The time was: ${{ steps.hello.outputs.time }}"
              echo "The message was: ${{ steps.hello.outputs.message }}"
    ```

    </details>

## Summary

In this lab you have learned how to:

- Create a custom Docker action with metadata file
- Define input and output parameters for actions
- Use a Dockerfile to containerize action logic
- Test custom actions in GitHub workflows
- Understand the basics of action publishing and versioning

Custom actions are powerful tools for creating reusable automation components that can be shared across teams and projects.

This exercise is inspired by the [GitHub official GitHub Actions training](https://github.com/ps-actions-sandbox/ActionsFundamentals)
