# Composite Actions
In this hands-on lab, you will create a composite action and a workflow that consumes it.

You will learn how to define an action, pass inputs to it, and use its outputs in the calling workflow. This is a great way to bundle multiple steps into a single, reusable command.

This hands-on lab consists of the following steps:

- Creating the action file

- Adding inputs and outputs

- Consuming the composite action

## Creating the action file
First, create a directory for your action. By convention, local actions are stored in the `.github/actions` directory. Create a new directory named `greet-action` inside `.github/actions`.

Create a new file inside that directory: `.github/actions/greet-action/action.yml`.

Set the name and description for your action. You can see an example below. 

```YAML
name: 'Greet and Set Time Action'
description: 'A composite action that greets someone and outputs the time.'
```

Add a `runs` block that specifies using: `composite` and add a single step that echoes "Hello". 

<details>
<summary>Solution</summary>

```YAML
runs:
  using: 'composite'
  steps:
    - name: Greet someone
      run: echo "Hello ${{ inputs.who-to-greet }}"
      shell: bash

```
</details>

## Adding inputs and outputs
Add an inputs block to your `action.yml`. Define an input named `who-to-greet` that is a required string with a default value of World. Then, update the `run` command to use this input.

<details>
<summary>Solution</summary>

```YAML
inputs:
  who-to-greet:
    description: 'The person to greet'
    type: string
    required: true
    default: 'World'

runs:
  using: 'composite'
  steps:
    - name: Greet someone
      run: echo "Hello ${{ inputs.who-to-greet }}"
      shell: bash
```
</details>

Add a second step with the `id` of `time`. This step will use a workflow command to set an output parameter named `current-time` to the current date.

<details>
<summary>Solution</summary>

```YAML
    - name: Set time
      id: time
      run: echo "time=$(date)" >> $GITHUB_OUTPUT
      shell: bash
```
</details>

Finally, add an `outputs` block to the `action.yml`. Define an output called `current-time` and set its value to the output from the `time` step.

<details>
<summary>Solution</summary>

outputs:
```YAML
  current-time:
    description: 'The time when greeting.'
    value: ${{ steps.time.outputs.time }}
```
</details>


<summary>Complete action.yml Solution</summary>

```YAML
name: 'Greet and Set Time Action'
description: 'A composite action that greets someone and outputs the time.'

inputs:
  who-to-greet:
    description: 'The person to greet'
    type: string
    required: true
    default: 'World'

outputs:
  current-time:
    description: 'The time when greeting.'
    value: ${{ steps.time.outputs.time }}

runs:
  using: 'composite'
  steps:
    - name: Greet someone
      run: echo "Hello ${{ inputs.who-to-greet }}"
      shell: bash
      
    - name: Set time
      id: time
      run: echo "time=$(date)" >> $GITHUB_OUTPUT
      shell: bash
```
</details>

## Consuming the composite action
Create a new file named `.github/workflows/test-composite.yml`.

Set the name to `Test Composite Action` and add a manual `workflow_dispatch` trigger.

<details>
<summary>Solution</summary>

```YAML
name: Test Composite Action

on: [workflow_dispatch]
```
</details>

Add a job named `run-action`. The first step must be `actions/checkout@v4` so your workflow can find your local composite action in the repository.

<details>
<summary>Solution</summary>

```YAML
jobs:
  run-action:
    runs-on: ubuntu-latest
    steps:
      - name: Check out repository
        uses: actions/checkout@v4
```
</details>

Add a second step to call your composite action. Give the step an `id` (e.g., greet_step) so you can access its outputs. Use the `with` keyword to pass in your username as the `who-to-greet` input. We can use the  `${{ github.actor }}` context to automatically add the username of the person who triggered the workflow.


<details>
<summary>Solution</summary>

```YAML
      - name: Run my composite action
        id: greet_step
        uses: ./.github/actions/greet-action
        with:
          who-to-greet: '${{ github.actor }}'
```
</details>

Add a final step to echo the `current-time` output from your action step.

```YAML
    - name: Use the output
      run: echo "The time was ${{ steps.greet_step.outputs.current-time }}"
```



<details>
<summary>Complete solution</summary>

```YAML

name: Test Composite Action

on: [workflow_dispatch]

jobs:
  run-action:
    runs-on: ubuntu-latest
    steps:
      - name: Check out repository
        uses: actions/checkout@v4

      - name: Run my composite action
        id: greet_step
        uses: ./.github/actions/greet-action
        with:
          who-to-greet: '${{ github.actor }}'

      - name: Use the output
        run: echo "The time was ${{ steps.greet_step.outputs.current-time }}"

```
</details>


Commit your files, run the workflow, and observe the output.

# Summary

In this lab, you have learned how to create a composite action that bundles multiple steps. 
You also learned how to define inputs and outputs for the action and how to call it from a workflow. 
Unlike reusable workflows which replace an entire job, composite actions act as a single, powerful step inside any job you choose.

If you are interested in trying out writing a Docker action, check out this exercise as part of the [GitHub official Github Actions training](https://github.com/ps-actions-sandbox/ActionsFundamentals)