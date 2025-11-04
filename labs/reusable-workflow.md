# Reusable workflow that uses a composite action

This lab builds on the composite action exercise. The reusable workflow will call the composite action `summary-action` (created earlier) to compute a small summary of a list of numbers and expose that summary as outputs. A consuming workflow will call the reusable workflow and then print the outputs.

Follow these steps:

## Create the reusable workflow

1. Create `.github/workflows/reusable.yml`.
2. Use the `workflow_call` trigger and add an input `numbers` of type `string` (JSON array encoded as a string). The input should have a default of `'[1,2,3]'`.
3. The workflow should run a job `summarize` which:
   - checks out the repository
   - calls the composite action `./.github/actions/summary-action` with the provided input
   - formats the JSON summary into a concise human-readable string
   - publishes both the JSON `summary` and the human-readable `summary_text` as job outputs
4. The workflow should expose outputs that map to the job outputs.

<details>
  <summary>Solution: reusable.yml</summary>

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
          description: 'Summary produced by the composite action (JSON)'
          value: ${{ jobs.summarize.outputs.summary }}
        summary_text:
          description: 'Human-readable summary text'
          value: ${{ jobs.summarize.outputs.summary_text }}

  jobs:
    summarize:
      runs-on: ubuntu-latest
      outputs:
        summary: ${{ steps.call-summary.outputs.summary }}
        summary_text: ${{ steps.format.outputs.summary_text }}
      steps:
        - uses: actions/checkout@v4

        - name: Call summary composite action
          id: call-summary
          uses: ./.github/actions/summary-action
          with:
            numbers: ${{ inputs.numbers }}

        - name: Format summary (create human-readable text)
          id: format
          shell: bash
          run: |
            printf '%s' '${{ steps.call-summary.outputs.summary }}' > summary.json || true
            echo "summary_text=$(cat summary.json)" >> $GITHUB_OUTPUT
            
            python3 ./ci/format_summary.py summary.json > summary_text.txt
            echo "summary_text=$(cat summary_text.txt)" >> $GITHUB_OUTPUT
  ```

</details>

## Create a consumer workflow

1. Create `.github/workflows/use-reusable.yml` with a `workflow_dispatch` trigger.
2. Add a job `call-reusable` that uses the reusable workflow `./.github/workflows/reusable.yml` and passes a custom `numbers` value.
3. Add a second job `show-summary` that depends on `call-reusable` and prints the outputs.

<details>
  <summary>Solution: use-reusable.yml (consumer)</summary>

  ```yaml
  name: Use reusable summary

  on: [workflow_dispatch]

  jobs:
    call-reusable:
      uses: ./.github/workflows/reusable.yml
      with:
        numbers: '[5, 15, 25, 35, 45]'

    show-summary:
      runs-on: ubuntu-latest
      needs: [call-reusable]
      steps:
        - name: Print reusable workflow outputs
          run: |
            echo "Reusable summary (JSON): ${{ needs.call-reusable.outputs.summary }}"
            echo "Reusable summary (text): ${{ needs.call-reusable.outputs.summary_text }}"
  ```

</details>

## Try it

- Make sure `ci/print_summary.py` is executable (if running on a GitHub runner the `python3` call will work).
- Commit the `action.yml` for the composite action, the `reusable.yml` workflow, and the consumer workflow.
- Dispatch `use-reusable.yml` from the GitHub Actions UI and inspect the `show-summary` job logs to see the outputs.

## Notes and tips

- The composite action uses stdin in the example to keep wiring trivial.
- In real actions you might want to validate inputs more strictly and avoid writing secrets to disk.
- This example shows how composite actions and reusable workflows can be composed to build small, testable building blocks.
