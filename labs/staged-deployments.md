# 🔨 Hands-on: Staged deployments

In this hands-on lab your will create environments and a staged deployment workflow with approvals.
> Note: you can only do this on public repos for free accounts. Adding environments for `private` repos is only available for Organizations with a Team account (or higher) and users with GitHub Pro accounts.

This hands on lab is based on the following steps:
- [Creating and protecting environments](#creating-and-protecting-environments)
- [Adding a input for picking environments to manual workflow trigger](#adding-a-input-for-picking-environments-to-manual-workflow-trigger)
- [Chaining workflow steps and conditional execution](#chaining-workflow-steps-and-conditional-execution)
- [Reviewing and approving deployments](#reviewing-and-approving-deployments)

## Creating and protecting environments

1. Go to [Settings](/../../settings) | [Environments](/../../settings/environments) and click [New environment](/../../settings/environments/new)
2. Enter the name `Production` and click `Configure environment`
3. Add yourself as the `Required reviewer` for this environment:

<img width="349" alt="image" src="https://user-images.githubusercontent.com/5276337/174113475-967127de-45a7-4dc9-8477-4de4df62c7e6.png">

4. Only allow the `main`branch to be deployed to this environment:

<img width="350" alt="image" src="https://user-images.githubusercontent.com/5276337/174113782-70a1b18a-0ab9-49fd-a53e-cb2ea78916e1.png">

5. Create two more environments. `Test` and `Load-Test` without any restrictions.

## Adding a input for picking environments to manual workflow trigger

Modify this workflow yml file.

```YAML
name: GitHub Actions Demo
on:
  push:
    branches: [ main ]
    paths-ignore: [.github/**]
  pull_request:
    branches: [ main ]
  schedule:
    - cron: '15 6 * * 0'
  workflow_dispatch:

  jobs:
  Build:
    runs-on: ubuntu-latest
    steps:
      - run: |
          echo "🎉 The job was triggered by event: ${{ github.event_name }}"
          echo "🔎 The name of your branch is ${{ github.ref }} and your repository is ."

      - uses: actions/checkout@v5

      - name: List files in the repository
        run: |
          echo "The repository ${{ github.repository }} contains the following files:"
          tree
```

Add an input of the type environment to the `workflow_dispatch` trigger that you created previously.

<details>
  <summary>Solution</summary>

```YAML
  workflow_dispatch:
    inputs:
      environment:
        description: 'Environment to deploy to'
        type: environment
        required: true
```

</details>

## Chaining workflow steps and conditional execution

1. Now add 3 jobs to the workflow file:
  - Test: runs on `ubuntu-latest` after `Build`. Only runs when the workflow was triggered manually. Runs on the environment `Test`. The job writes `Testing...` to the workflow log.
  - Load-Test: runs on `ubuntu-latest` after `Build`. Only runs when the workflow was triggered manually. Runs on the environment `Load-Test`. The job writes `Testing...` to the workflow log and sleeps for 15 seconds.
  - Production: runs on `ubuntu-latest` after `Test` and `Load-Test`. Deploys to the environment `Production` onyl if this was selected as the input parameter. The environment has the URL `https://writeabout.net`. To simulate deployment, the job will execute 5 steps. Each step with writes `Step x deploying...` to the workflow log and sleeps for 10 seconds.

<details>
  <summary>Solution</summary>

```YAML
  Test:
    runs-on: ubuntu-latest
    if: github.event_name == 'workflow_dispatch'
    needs: Build
    environment: Test
    steps:
      - run: echo "🧪 Testing..."

  Load-Test:
    runs-on: ubuntu-latest
    if: github.event_name == 'workflow_dispatch'
    needs: Build
    environment: Load-Test
    steps:
      - run: |
          echo "🧪 Testing..."
          sleep 15

  Production:
    runs-on: ubuntu-latest
    needs: [Test, Load-Test]
    environment:
      name: Production
      url: https://writeabout.net
    if: github.event.inputs.environment == 'Production'
    steps:
      - run: |
          echo "🚀 Step 1..."
          sleep 10
      - run: |
          echo "🚀 Step 2..."
          sleep 10
      - run: |
          echo "🚀 Step 3..."
          sleep 10
      - run: |
          echo "🚀 Step 4..."
          sleep 10
      - run: |
          echo "🚀 Step 5..."
          sleep 10
```

</details>

2. Trigger the workflow and select `Production` as the environment:

<img width="212" alt="image" src="https://user-images.githubusercontent.com/5276337/174119722-9b76d479-e355-414b-a534-03d8634536ef.png">

## Reviewing and approving deployments

1. Open the workflow run and start the review.

<img width="600" alt="image" src="https://user-images.githubusercontent.com/5276337/174120029-f395e8ec-5e6e-4350-94c5-130caefaafc2.png">

2. And approve it with a comment:

<img width="350" alt="image" src="https://user-images.githubusercontent.com/5276337/174120086-fed98feb-2d7f-476b-a997-1aa099de7d0e.png">

3. Note the progress bar while deploying...

<img width="200" alt="image" src="https://user-images.githubusercontent.com/5276337/174120314-c900585c-6b94-4fc2-8fe9-92452b0cf187.png">

4. The result looks like this and contains the approval and the URL for the production environment:

<img width="800" alt="image" src="https://user-images.githubusercontent.com/5276337/174120381-cef48594-6663-481a-aadd-1ef0dbd50b0a.png">

## Summary

In this lab you have learned to create and protect environments in GitHub and use them in a workflow. You have also learned to conditionally
execute jobs or steps and to chain jobs using the `needs` keyword.
