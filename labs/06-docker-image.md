## Making docker images

Often we also want to have our application packaged as a docker image for easy distribution. Lucky for us, Github Actions has nice support for Docker built in.

The following is an example of a job that builds and pushes a Docker image:

``` yaml
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

To try this on the project, we have made two scripts: `ci/build-docker.sh` and `ci/push-docker.sh`
In order for this to work, two env. variables needs to be set: `docker_username` and `docker_password`. It can be done by adding below section on the top of the workflow file:

```YAML
env: 
  docker_username: ${{ secrets.DOCKER_USERNAME }}
  docker_password: ${{ secrets.DOCKER_PASSWORD}}
```

### Tasks

1. Add a new job named `Docker-image` that requires the `Build` and `Test` jobs have been run.
2. Add `docker_username` and `docker_password` as environmental variables. 
3. Then run the `ci/build-docker.sh` and `ci/push-docker.sh` scripts with `export GIT_COMMIT="GA-$GITHUB_SHA"`.

> Hint: Remember that the job needs to run on specified system and is based on the results from previous jobs. 

> Hint: You can find lots of information about `$GITHUB_SHA` and the other environment variables provided by Github Actions in  https://docs.github.com/en/enterprise-server@2.22/actions/reference/environment-variables