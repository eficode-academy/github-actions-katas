# Building Docker Images

Often we also want to have our application packaged as a docker image for easy distribution. Lucky for us, Github Actions has nice support for Docker built in.

To try this on the project, we have made two scripts: `ci/build-docker.sh` and `ci/push-docker.sh`
In order for this to work, two env. variables needs to be set: `docker_username` and `docker_password`. It can be done by adding below section on the top of the workflow file:

```YAML
env:
  docker_username: ${{ secrets.DOCKER_USERNAME }}
  docker_password: ${{ secrets.DOCKER_PASSWORD }}
```

We should give our docker image a meaningful tag, for example we could give it a tag based on the git commit that triggered build.
This is what the two scripts: `ci/build-docker.sh` and `ci/push-docker.sh` expects, and they will read the name of the git commit from an environment variable named `GIT_COMMIT`, which we must define.

### Tasks
To start Docker credentials should be stored as secrets at Github Actions Repository. Please go to `Settings > Secrets > Add Secret` to add them. 

[Github Secrets](img/secret.png)

1. Add a new job named `Docker-image` that requires the `Build` and `Test` jobs have been run.
2. Add a new step to your `Build` job which uploads the build code, and then a step in `Docker-image` which downloads the build.
3. Add `docker_username` and `docker_password` as environmental variables.
4. Then run the `ci/build-docker.sh` and `ci/push-docker.sh` scripts with `export GIT_COMMIT="GA-$GITHUB_SHA"`.

> Hint: Remember that the job needs to run on specified system and is based on the results from previous jobs.

> Hint: You can find lots of information about `$GITHUB_SHA` and the other environment variables provided by Github Actions in https://docs.github.com/en/enterprise-server@2.22/actions/reference/environment-variables

---

The above job can be also done by using actions: `docker/login-action@v1` and `docker/build-push-action@v2`, what will provide the same functionality. You can find it in the example below:

```yaml
on: push
jobs:
  build-and-push-latest:
    runs-on: ubuntu-latest
    steps:
      - name: Login to DockerHub
        uses: docker/login-action@v1
        with:
          username: ${{ env.docker_username }}
          password: ${{ env.docker_password }}
      - name: Build and push
        uses: docker/build-push-action@v2
        with:
          push: true
          tags: my-org/my-image:latest
```
