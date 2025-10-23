# Reusable workflow that uses a composite action

This lab builds on the composite action exercise. Instead of greeting someone, the reusable workflow will call the composite action `summary-action` (created in the previous exercise) to compute a small summary of a list of numbers and expose that summary as a workflow output. A consuming workflow will call the reusable workflow and then print the output.

Follow these steps:

## Create the reusable workflow

1. Create `.github/workflows/reusable-2.yml`.
2. Use the `workflow_call` trigger and add an input `numbers` of type `string` (JSON array encoded as a string). The input should have a default of `[1,2,3]`.
3. The workflow should run a job `summarize` which:
   - checks out the repository
   - calls the composite action `./.github/actions/summary-action` with the provided input
   - publishes the composite action's `summary` as a job output
4. The workflow should expose an output `summary` which maps to the job output.

<details>
  <summary>Solution: reusable-2.yml</summary>

```yaml
name: Reusable summary workflow

on:
  workflow_call:
    inputs:
      numbers:
        description: 'JSON array of numbers as a string'
        type: string
        required: true
        default: '[1,2,3]'
    outputs:
      summary:
        description: 'Summary produced by the composite action'
        value: ${{ jobs.summarize.outputs.summary }}

jobs:
  summarize:
    runs-on: ubuntu-latest
    outputs:
      summary: ${{ steps.call-summary.outputs.summary }}
    steps:
      - uses: actions/checkout@v4

      - name: Call summary composite action
        id: call-summary
        uses: ./.github/actions/summary-action
        with:
          numbers: ${{ inputs.numbers }}
```
</details>

## Create a consumer workflow

1. Create `.github/workflows/use-reusable-2.yml` with a `workflow_dispatch` trigger.
2. Add a job `call-reusable` that uses the reusable workflow `./.github/workflows/reusable-2.yml` and passes a custom `numbers` value.
3. Add a second job `show-summary` that depends on `call-reusable` and prints the output.

<details>
  <summary>Solution: use-reusable-2.yml (consumer)</summary>

```yaml
name: Use reusable summary

on: [workflow_dispatch]

jobs:
  call-reusable:
    uses: ./.github/workflows/reusable-2.yml
    with:
      numbers: '[5, 15, 25, 35, 45]'

  show-summary:
    runs-on: ubuntu-latest
    needs: [call-reusable]
    steps:
      - name: Print reusable workflow output
        run: echo "Reusable summary: ${{ needs.call-reusable.outputs.summary }}"
```
</details>

## Try it

- Make sure `ci/print_summary.py` is executable (if running on a GitHub runner the `python3` call will work).
- Commit the `action.yml` for the composite action, the `reusable-2.yml` workflow, and the consumer workflow.
- Dispatch `use-reusable-2.yml` from the GitHub Actions UI and inspect the `show-summary` job logs to see the JSON summary.

## Notes and tips

- The composite action uses stdin in the example to keep wiring trivial.
- In real actions you might want to validate inputs more strictly and avoid writing secrets to disk.
- This example shows how composite actions and reusable workflows can be composed to build small, testable building blocks.
# Reusable workflow that uses a composite action

This lab builds on the composite action exercise. Instead of greeting someone, the reusable workflow will call the composite action `summary-action` (created in the previous exercise) to compute a small summary of a list of numbers and expose that summary as a workflow output. A consuming workflow will call the reusable workflow and then print the output.

Follow these steps:

## Create the reusable workflow

1. Create `.github/workflows/reusable-2.yml`.
2. Use the `workflow_call` trigger and add an input `numbers` of type `string` (JSON array encoded as a string). The input should have a default of `[1,2,3]`.
3. The workflow should run a job `summarize` which:
   - checks out the repository
   - calls the composite action `./.github/actions/summary-action` with the provided input
   - publishes the composite action's `summary` as a job output
4. The workflow should expose an output `summary` which maps to the job output.

<details>
  <summary>Solution: reusable-2.yml</summary>

```yaml
name: Reusable summary workflow

on:
  workflow_call:
    inputs:
      numbers:
        description: 'JSON array of numbers as a string'
        type: string
        required: true
        default: '[1,2,3]'
    outputs:
      summary:
        description: 'Summary produced by the composite action'
        value: ${{ jobs.summarize.outputs.summary }}

jobs:
  summarize:
    runs-on: ubuntu-latest
    outputs:
      summary: ${{ steps.call-summary.outputs.summary }}
    steps:
      - uses: actions/checkout@v4

      - name: Call summary composite action
        id: call-summary
        uses: ./.github/actions/summary-action
        with:
          numbers: ${{ inputs.numbers }}
```
</details>

## Create a consumer workflow

1. Create `.github/workflows/use-reusable-2.yml` with a `workflow_dispatch` trigger.
2. Add a job `call-reusable` that uses the reusable workflow `./.github/workflows/reusable-2.yml` and passes a custom `numbers` value.
3. Add a second job `show-summary` that depends on `call-reusable` and prints the output.

<details>
  <summary>Solution: use-reusable-2.yml (consumer)</summary>

```yaml
name: Use reusable summary

on: [workflow_dispatch]

jobs:
  call-reusable:
    uses: ./.github/workflows/reusable-2.yml
    with:
      numbers: '[5, 15, 25, 35, 45]'

  show-summary:
    runs-on: ubuntu-latest
    needs: [call-reusable]
    steps:
      - name: Print reusable workflow output
        run: echo "Reusable summary: ${{ needs.call-reusable.outputs.summary }}"
```
</details>

## Try it

- Make sure `ci/print_summary.py` is executable (if running on a GitHub runner the `python3` call will work).
- Commit the `action.yml` for the composite action, the `reusable-2.yml` workflow, and the consumer workflow.
- Dispatch `use-reusable-2.yml` from the GitHub Actions UI and inspect the `show-summary` job logs to see the JSON summary.

## Notes and tips

- The composite action uses stdin in the example to keep wiring trivial.
- In real actions you might want to validate inputs more strictly and avoid writing secrets to disk.
- This example shows how composite actions and reusable workflows can be composed to build small, testable building blocks.
# Reusable workflow that uses a composite action

This lab builds on the composite action exercise. Instead of greeting someone, the reusable workflow will call the composite action `summary-action` (created in the previous exercise) to compute a small summary of a list of numbers and expose that summary as a workflow output. A consuming workflow will call the reusable workflow and then print the output.

Follow these steps:

## Create the reusable workflow

1. Create `.github/workflows/reusable-2.yml`.
2. Use the `workflow_call` trigger and add an input `numbers` of type `string` (JSON array encoded as a string). The input should have a default of `[1,2,3]`.
3. The workflow should run a job `summarize` which:
   - checks out the repository
   - calls the composite action `./.github/actions/summary-action` with the provided input
   - publishes the composite action's `summary` as a job output
4. The workflow should expose an output `summary` which maps to the job output.

<details>
  <summary>Solution: reusable-2.yml</summary>

```yaml
name: Reusable summary workflow

on:
  workflow_call:
    inputs:
      numbers:
        description: 'JSON array of numbers as a string'
        type: string
        required: true
        default: '[1,2,3]'
    outputs:
      summary:
        description: 'Summary produced by the composite action'
        value: ${{ jobs.summarize.outputs.summary }}

jobs:
  summarize:
    runs-on: ubuntu-latest
    outputs:
      summary: ${{ steps.call-summary.outputs.summary }}
    steps:
      - uses: actions/checkout@v4

      - name: Call summary composite action
        id: call-summary
        uses: ./.github/actions/summary-action
        with:
          numbers: ${{ inputs.numbers }}
```
</details>

## Create a consumer workflow

1. Create `.github/workflows/use-reusable-2.yml` with a `workflow_dispatch` trigger.
2. Add a job `call-reusable` that uses the reusable workflow `./.github/workflows/reusable-2.yml` and passes a custom `numbers` value.
3. Add a second job `show-summary` that depends on `call-reusable` and prints the output.

<details>
  <summary>Solution: use-reusable-2.yml (consumer)</summary>

```yaml
name: Use reusable summary

on: [workflow_dispatch]

jobs:
  call-reusable:
    uses: ./.github/workflows/reusable-2.yml
    with:
      numbers: '[5, 15, 25, 35, 45]'

  show-summary:
    runs-on: ubuntu-latest
    needs: [call-reusable]
    steps:
      - name: Print reusable workflow output
        run: echo "Reusable summary: ${{ needs.call-reusable.outputs.summary }}"
```
</details>

## Try it

- Make sure `ci/print_summary.py` is executable (if running on a GitHub runner the `python3` call will work).
- Commit the `action.yml` for the composite action, the `reusable-2.yml` workflow, and the consumer workflow.
- Dispatch `use-reusable-2.yml` from the GitHub Actions UI and inspect the `show-summary` job logs to see the JSON summary.

## Notes and tips

- The composite action is simple and purposely uses stdin in the example to keep wiring trivial.
- In real actions you might want to validate inputs more strictly and avoid writing secrets to disk.
- This example shows how composite actions and reusable workflows can be composed to build small, testable building blocks.
# Reusable workflow that uses a composite action

This lab builds on the composite action exercise. Instead of greeting someone, the reusable workflow will call the composite action `summary-action` (created in the previous exercise) to compute a small summary of a list of numbers and expose that summary as a workflow output. A consuming workflow will call the reusable workflow and then print the output.

Follow these steps:

## Create the reusable workflow

1. Create `.github/workflows/reusable-2.yml`.
2. Use the `workflow_call` trigger and add an input `numbers` of type `string` (JSON array encoded as a string). The input should have a default of `[1,2,3]`.
3. The workflow should run a job `summarize` which:
   - checks out the repository
   - calls the composite action `./.github/actions/summary-action` with the provided input
   - publishes the composite action's `summary` as a job output
4. The workflow should expose an output `summary` which maps to the job output.

        description: 'Summary produced by the composite action'
        uses: ./.github/actions/summary-action
## Create the reusable workflow

1. Create `.github/workflows/reusable-2.yml`.
2. Use the `workflow_call` trigger and add an input `numbers` of type `string` (JSON array encoded as a string). The input should have a default of `[1,2,3]`.
3. The workflow should run a job `summarize` which:
   - checks out the repository
   - calls the composite action `./.github/actions/summary-action` with the provided input
   - publishes the composite action's `summary` as a job output
4. The workflow should expose an output `summary` which maps to the job output.

<details>
  <summary>Solution</summary>

```yaml
name: Reusable summary workflow

name: Use reusable summary
  workflow_call:
    inputs:
      numbers:
        description: 'JSON array of numbers as a string'
        type: string
        required: true
        default: '[1,2,3]'
    outputs:
      summary:
        description: 'Summary produced by the composite action'
        value: ${{ jobs.summarize.outputs.summary }}


  summarize:
    runs-on: ubuntu-latest
    outputs:
      summary: ${{ steps.call-summary.outputs.summary }}
    steps:
      - uses: actions/checkout@v4

      - name: Call summary composite action
        id: call-summary
        uses: ./.github/actions/summary-action
        with:
          numbers: ${{ inputs.numbers }}
```
</details>
on: [workflow_dispatch]
    uses: ./.github/workflows/reusable-2.yml
      numbers: '[5, 15, 25, 35, 45]'
<details>
  <summary>Solution</summary>

```yaml
name: Use reusable summary

- Commit the `action.yml` for the composite action, the `reusable-2.yml` workflow, and the consumer workflow.

- Dispatch `use-reusable-2.yml` from the GitHub Actions UI and inspect the `show-summary` job logs to see the JSON summary.
  call-reusable:
    uses: ./.github/workflows/reusable-2.yml
    with:
      numbers: '[5, 15, 25, 35, 45]'

  show-summary:
    runs-on: ubuntu-latest
    needs: [call-reusable]
    steps:
      - name: Print reusable workflow output
        run: echo "Reusable summary: ${{ needs.call-reusable.outputs.summary }}"
```
</details>

## Notes and tips

- The composite action is simple and purposely uses a temporary file to demonstrate passing multi-line or structured inputs into scripts.
- In real actions you might want to validate inputs more strictly and avoid writing secrets to disk.
- This example shows how composite actions and reusable workflows can be composed to build small, testable building blocks.

