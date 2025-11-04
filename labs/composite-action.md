# Composite actions

In this hands-on lab you'll create a small composite action that runs a few shell steps plus the Python helper located at `ci/print_summary.py`.

The goal is to learn how to: create a composite action, accept inputs, expose outputs, and call it from a workflow.

This lab contains the following steps:

- Create the composite action metadata
- Use the composite action in a simple workflow
- Run the workflow locally (or on GitHub Actions) and inspect the output

## Create the composite action

1. Create a new directory `.github/actions/summary-action` in the repository.
2. Add an `action.yml` file with the following behaviour:

   - Accept an input `numbers` which is a JSON array encoded as a string (for simplicity)
   - Pipe that string to the Python helper `ci/print_summary.py` via stdin
   - Save the printed JSON summary to an output parameter called `summary`

  For more information on action metadata format and the composite action syntax, see the GitHub Docs: <https://docs.github.com/en/actions/tutorials/create-actions/create-a-composite-action#creating-an-action-metadata-file>

<details>
  <summary>Solution</summary>

  ```yaml
  name: Summary action
  description: "Pipe numbers into a Python helper and print a small summary"
  inputs:
    numbers:
      description: 'JSON array of numbers as a string, e.g. "[1,2,3]"'
      required: true
  outputs:
    summary:
      description: 'JSON summary produced by the helper'
      value: ${{ steps.set-output.outputs.summary }}
  runs:
    using: "composite"
    steps:
      - name: Run python summarizer (stdin)
        shell: bash
        run: |
          echo "${{ inputs.numbers }}" | python3 ci/print_summary.py > summary.json
          cat summary.json

      - name: Set output
        id: set-output
        shell: bash
        run: echo "summary=$(cat summary.json)" >> $GITHUB_OUTPUT
  ```

</details>

Notes:

- The composite action uses the `composite` runner so it can string together multiple steps.
- We store the temporary file path in an intermediate output (optional). The important part is that the final step writes the `summary` to `$GITHUB_OUTPUT` so the action exposes the output.

## Use the composite action

1. Create a workflow `.github/workflows/use-summary.yml` with a manual trigger (`workflow_dispatch`).
2. Add a job that calls the action with a `numbers` value.

Example consumer (solution):

<details>
  <summary>Solution</summary>

  ```yaml
  name: Use summary action

  on: [workflow_dispatch]

  jobs:
    call-summary:
      runs-on: ubuntu-latest
      steps:
        - uses: actions/checkout@v4

        - name: Call summary composite action
          id: summary
          uses: ./.github/actions/summary-action
          with:
            numbers: '[10, 20, 30, 40]'

        - name: Print action output
          run: |
            echo "Summary output: ${{ steps.summary.outputs.summary }}"
  ```

</details>

## Run the workflow

- You can dispatch the workflow from the GitHub UI (Workflow -> Run workflow) or run the steps locally using a runner that supports Actions (for example, act). The important part is that the workflow demonstrates how inputs and outputs flow through the composite action.

## Summary

You've created a composite action that runs multiple steps and produces an output. You also learned how to call that composite action from a workflow and read its outputs.
