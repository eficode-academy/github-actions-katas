## Starter Workflows & Organizational Sharing

### **Starter Workflows**

- **What:** Starter workflows allow everyone in your organization who has permission to create workflows to do so more quickly and easily

- **Why?**
    - time saver
    - promotes consistency
    - serves as exemplar for following best practices

### Task

Let's dive 🤿 in and create an organization, a starter workflow, and then run it! 🏃‍♀️

- Go github.com and create a new organization from the `+` dropdown menu
  
![Screenshot workflow](img/create-organization.png)
- Select the free tier option ("create a free organization")
- Set the organization name to anything you wish (must be unique across Github), and use your first.last@eficode.com email for the contact.
- Set `this organization belongs to` "My personal account"
- Attempt to prove you're not a robot 🤖🖼️ (good luck)
- Accept the TOS (after reading of course 📖), and click next
- On the Welcome page click `skip this step` on the bottom
- Spam click the submit option on the bottom of the page to bypass the survey information
- click the `Repository` tab
- Create a new repository
- Choose `.github` as the repository name (*required in order to make the 🪄 work   *)
- 📝 set visibility to public 👀
- Click the `Create repositiory` button on the bottom
- Create a directory named `workflow-templates`

<details>
    <summary>create a `/workflow-templates/my-org-ci.yml` file</summary>

```YAML
name: Octo Organization CI

on:
  push:
    branches: [ $default-branch ]
  pull_request:
    branches: [ $default-branch ]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v3

      - name: Run a one-line script
        run: echo Hello from Octo Organization
```
</details>

<details>
    <summary>create a `/workflow-templates/my-org.properties.json` file</summary>

```JSON
{
    "name": "Octo Organization Workflow",
    "description": "Octo Organization CI starter workflow.",
    "iconName": "example-icon",
    "categories": [
        "node", "js"
    ],
    "filePatterns": [
        "package.json$",
        "^Dockerfile",
        ".*\\.md$",
        ".*\.ya?ml"
    ]
}
```
</details>

---
## Using the Starter Workflow

- Go to the Actions tab on the .github (or any repo owned by the org) and you should see a section "By Organization name"

click configure
click start commit
commit to main branch (create new file)
go back to Actions and click on build and then you should see the steps

---
## Organizational Sharing

- Assets that can be shared organization wide: 
  - starter workflows (as above)
  - secrets & variables
    - Navigate to main organization page and click on settings
![Screenshot variables & secrets](img/organization-settings-tab.png)
    - Find the `Secrets and variables` section, expand, and click `Actions`
![Screenshot variables & secrets](img/secrets-and-variables.png)

  - Self-hosted Runners
    - A self-hosted runner is automatically removed from GitHub if it has not connected to GitHub Actions for more than 14 days.
An ephemeral self-hosted runner is automatically removed from GitHub if it has not connected to GitHub Actions for more than 1 day.
    - Can be added at the repo, organization, or enterprise level

### Task - *creating a self-hosted runner*
- Navigate to the Home page of your organization (github.com/my-org)
- Go to Settings -> Actions -> Runners and click the
    <img style="position: relative; top: 20px" src="img/new-self-hosted-runner.png"> button<br><br>
    - Walk through the `Download` and `Configure` steps<br>
        <details>
            <summary>Example 'Download' steps using Linux x64</summary>
        - Create a change to folder directory:<br>
            &nbsp;&nbsp;&nbsp;&nbsp;$ mkdir actions-runner && cd actions-runner<br>
        - Download the latest runner package <br>
            &nbsp;&nbsp;&nbsp;&nbsp;$ curl -o actions-runner-linux-x64-2.300.2.tar.gz -L https://github.com/actions/runner/releases/download/v2.300.2/actions-runner-linux-x64-2.300.2.tar.gz<br>
        - Validate the hash<br>
            &nbsp;&nbsp;&nbsp;&nbsp;$ echo "ed5bf2799c1ef7b2dd607df66e6b676dff8c44fb359c6fedc9ebf7db53339f0c  actions-runner-linux-x64-2.300.2.tar.gz" | shasum -a 256 -c
        - Extract<br>
            &nbsp;&nbsp;&nbsp;&nbsp;$ tar xzf ./actions-runner-linux-x64-2.300.2.tar.gz
        </details>

        <details>
            <summary>Example 'Configure' steps</summary>
            - Create the runner and start the configuration experience<br>
            &nbsp;&nbsp;&nbsp;&nbsp;$ ./config.sh --url https://github.com/my-organization --token *****<br>
            - Last step, run it!<br>
            &nbsp;&nbsp;&nbsp;&nbsp;$ ./run.sh
        </details>

    - After completing the registration, you need to fire up the runner to listen for requests by running `./run.sh`

## Resources

[Creating](https://docs.github.com/en/actions/using-workflows/creating-starter-workflows-for-your-organization) starter workflows

[Using](https://docs.github.com/en/actions/using-workflows/using-starter-workflows) starter workflows

[Organizational sharing](https://docs.github.com/en/actions/using-workflows/sharing-workflows-secrets-and-runners-with-your-organization) - workflows, variables, secrets, and self-hosted runners

Adding [self-hosted runners](https://docs.github.com/en/actions/hosting-your-own-runners/adding-self-hosted-runners)