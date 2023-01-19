# Self-hosted Runners

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

Adding [self-hosted runners](https://docs.github.com/en/actions/hosting-your-own-runners/adding-self-hosted-runners)

[Sharing self-hosted runners within an organization](https://docs.github.com/en/actions/using-workflows/sharing-workflows-secrets-and-runners-with-your-organization#share-self-hosted-runners-within-an-organization)
