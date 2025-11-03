# Workflow Concurrency

GitHub Actions can run multiple workflows simultaneously, but sometimes you want to control this behavior to prevent conflicts or resource contention. Workflow concurrency allows you to limit the number of workflow runs that can execute at the same time.

:bulb: Concurrency is particularly useful for deployment workflows where you don't want multiple deployments running simultaneously.

## Learning Goals

- Understand how to configure workflow concurrency groups
- Learn how to cancel in-progress workflows when new ones start
- Practice using workflow artifacts to pass data between jobs
- Experience workflow summaries and output grouping

## Understanding Workflow Concurrency

In this exercise, we will create a workflow that demonstrates concurrency control by:

- Setting up a concurrency group to manage workflow runs
- Creating jobs that generate and process artifacts
- Using workflow summaries to display results
- Simulating work with delays to observe concurrency behavior

The workflow will have two jobs that work together: one that generates a directory tree listing and uploads it as an artifact, and another that downloads the artifact and creates a workflow summary.

[Documentation](https://docs.github.com/en/actions/writing-workflows/choosing-what-your-workflow-does/control-the-concurrency-of-workflows-and-jobs)

## Task

1. **Set Up the Workflow File**  
   Create a new workflow file named `concurrency-lab.yml` in the `.github/workflows` directory of your repository. Set the workflow name to "Concurrency Demo" and configure it to be triggered manually using the `workflow_dispatch` event.

2. **Define Concurrency Settings**  
   Add a concurrency group that uses the workflow name and reference. Enable the option to cancel any in-progress runs if a new one starts.

<details>
  <summary>Solution</summary>

```YAML
concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true 
```

</details>

3. **Create the 'upload-tree' Job**  
   Add a job that runs on the latest Ubuntu runner with the following steps:
   - Check out the repository
   - Generate directory tree using the provided script
   - Upload the tree output as an artifact
   - Simulate work by pausing for 10 seconds

<details>
  <summary>Solution</summary> 

```YAML
  upload-tree:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout 
        uses: actions/checkout@v4

      - name: Generate directory tree
        run: helper-scripts/generate-tree.sh

      - name: Upload tree output
        uses: actions/upload-artifact@v4
        with:
          name: tree-output
          path: tree.txt

      - name: Simulate work
        run: sleep 10
```

</details>

4. **Create the 'add-summary' Job**  
   Add a second job that depends on the first job and runs on the latest Ubuntu runner with the following steps:
   - Download the tree artifact
   - Simulate work by pausing for 10 seconds
   - Add a [workflow summary](https://github.blog/news-insights/product-news/supercharging-github-actions-with-job-summaries/) showing the directory tree

<details>
    <summary>Solution</summary>
    
```YAML
  add-summary:
    runs-on: ubuntu-latest
    needs: upload-tree
    steps:
      - name: Download tree output
        uses: actions/download-artifact@v4
        with:
          name: tree-output

      - name: Simulate work
        run: sleep 10

      - name: Add job summary with tree output
        run: |
          echo "### Job completed! :rocket:" >> $GITHUB_STEP_SUMMARY
          echo '### Project Directory Tree' >> $GITHUB_STEP_SUMMARY
          echo '```' >> $GITHUB_STEP_SUMMARY
          cat tree.txt >> $GITHUB_STEP_SUMMARY
          echo '```' >> $GITHUB_STEP_SUMMARY
```

</details>

5. **Test the Concurrency Behavior**  
   Save and commit the workflow file, then go to the Actions tab in your GitHub repository. Trigger the workflow twice in quick succession to observe that only the jobs from the last triggered workflow will run, as earlier runs will be cancelled due to the concurrency settings.

<details>
<summary>:bulb: Git commands to commit the files</summary>

```bash
git add .github/workflows/concurrency-lab.yml ci/generate-tree.sh
git commit -m "Add concurrency workflow demonstration"
git push
```

</details>

### Results

You should see that when you trigger the workflow multiple times rapidly:
- Only the most recent workflow run completes
- Previous runs are cancelled automatically
- The workflow summary displays the project directory tree
- The concurrency group prevents multiple simultaneous runs

<details>
  <summary>Complete Solution</summary>

```YAML
name: Concurrency Demo

on:
    workflow_dispatch:

concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

jobs:
  upload-tree:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout 
        uses: actions/checkout@v4

      - name: Generate directory tree
        run: helper-scripts/generate-tree.sh

      - name: Upload tree output
        uses: actions/upload-artifact@v4
        with:
          name: tree-output
          path: tree.txt

      - name: Simulate work
        run: sleep 10  

  add-summary:
    runs-on: ubuntu-latest
    needs: upload-tree
    steps:
      - name: Download tree output
        uses: actions/download-artifact@v4
        with:
          name: tree-output

      - name: Simulate work
        run: sleep 10

      - name: Add job summary with tree output
        run: |
          echo "### Job completed! :rocket:" >> $GITHUB_STEP_SUMMARY
          echo '### Project Directory Tree' >> $GITHUB_STEP_SUMMARY
          echo '```' >> $GITHUB_STEP_SUMMARY
          cat tree.txt >> $GITHUB_STEP_SUMMARY
          echo '```' >> $GITHUB_STEP_SUMMARY
```

</details>

## Summary

Congratulations! You have successfully implemented workflow concurrency controls. You've learned how to:

- Configure concurrency groups to prevent simultaneous workflow runs
- Use the `cancel-in-progress` option to automatically cancel outdated runs
- Work with artifacts to pass data between jobs
- Create workflow summaries for better visibility into your pipeline results

This concurrency pattern is especially valuable for deployment workflows where you want to ensure only one deployment happens at a time, preventing conflicts and ensuring consistency.

