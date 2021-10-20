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
- To start Docker credentials should be stored as secrets at Github Actions Repository. Please go to `Settings > Secrets > Add Secret` to add them. 

[Github Secrets](img/secret.png)

___

- Add a new job named `Docker-image` that requires the `Build` and `Test` jobs have been run.

```YAML
  Docker-image:
    runs-on: ubuntu-latest
    needs: [Build,Test]
```
___
- Add a new step to your `Build` job which uploads the build code, and then a step in `Docker-image` which downloads the build by using aritifact actions `actions/upload-artifact@v2` and `actions/download-artifact@v1`.

___
- Add `docker_username` and `docker_password` as environmental variables on top of the workflow file. 

```YAML
env:
  docker_username: ${{ secrets.DOCKER_USERNAME }}
  docker_password: ${{ secrets.DOCKER_PASSWORD }}
```

___
- Then run the `ci/build-docker.sh` and `ci/push-docker.sh` scripts with `export GIT_COMMIT="GA-$GITHUB_SHA"`.

Where `ci/build-docker.sh` bash script will build docker based on Micronaut application tag. 
```bash 
#!/bin/bash
[[ -z "${GIT_COMMIT}" ]] && Tag='local' || Tag="${GIT_COMMIT::8}"
[[ -z "${docker_username}" ]] && DockerRepo='' || DockerRepo="${docker_username}/"
docker build -t "${DockerRepo}micronaut-app:latest" -t "${DockerRepo}micronaut-app:1.0-$Tag" app/
```

`ci/push-docker.sh` will login push your docker image to DockerHub.
```bash
#!/bin/bash
echo "$docker_password" | docker login --username "$docker_username" --password-stdin
docker push "$docker_username/micronaut-app:1.0-${GIT_COMMIT::8}" 
docker push "$docker_username/micronaut-app:latest" &
wait
```
Ready steps looks like:
```YAML
    - name: build docker
      run: chmod +x ci/build-docker.sh && export GIT_COMMIT="GA-$GITHUB_SHA" && ci/build-docker.sh
    - name: push docker
      run: chmod +x ci/push-docker.sh && export GIT_COMMIT="GA-$GITHUB_SHA" && ci/push-docker.sh
```

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

### Solution 
If you strugle and need to see the whole ***Solution*** you can extend the section below. 
<details>
    <summary> Solution </summary>
  
```YAML
name: Java CI
on: push
env: # Set the secret as an input
  docker_username: ${{ secrets.DOCKER_USERNAME }}
  docker_password: ${{ secrets.DOCKER_PASSWORD }}
jobs:
  Clone-down:
    name: Clone down repo
    runs-on: ubuntu-latest
    container: gradle:6-jdk11
    steps:
    - uses: actions/checkout@v2
    - name: Upload Repo
      uses: actions/upload-artifact@v2
      with:
        name: code
        path: .
  Test:
    runs-on: ubuntu-latest
    needs: Clone-down
    container: gradle:6-jdk11
    steps:
    - name: Download code
      uses: actions/download-artifact@v2
      with:
        name: code
        path: . 
    - name: Test with Gradle
      run: chmod +x ci/unit-test-app.sh && ci/unit-test-app.sh
  Build:
    runs-on: ubuntu-latest
    needs: Clone-down
    container: gradle:6-jdk11
    steps:
    - name: Download code
      uses: actions/download-artifact@v2
      with:
        name: code
        path: .
    - name: Build with Gradle
      run: chmod +x ci/build-app.sh && ci/build-app.sh
    - name: Upload Repo
      uses: actions/upload-artifact@v2
      with:
        name: code
        path: .
  Docker-image:
    runs-on: ubuntu-latest
    needs: [Build,Test]
    steps:
    - name: Download code
      uses: actions/download-artifact@v1
      with:
        name: code
        path: .
    - name: build docker
      run: chmod +x ci/build-docker.sh && export GIT_COMMIT="GA-$GITHUB_SHA" && ci/build-docker.sh
    - name: push docker
      run: chmod +x ci/push-docker.sh && export GIT_COMMIT="GA-$GITHUB_SHA" && ci/push-docker.sh
```

</details>


### Results

You should be able to see your docker image on your DockerHub account as: 


