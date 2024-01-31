# Extending the pipeline

After the application is build, the unit test should be performed to check if it works as expected. 

This part is made as a recap of the previous exercise, to remind you how to add a step to the pipeline.

## Learning goals

- Add a step to the pipeline

## Exercise

### Tasks

- Add a step running the unit test named `Test`, 
- The step should `run` the script `ci/unit-test-app.sh`. If you want to know what the script is doing, look into [the script](../ci/unit-test-app.sh).

## Solution

If you strugle and need to see the whole ***Solution*** you can extend the section below. 
<details>
    <summary> Solution </summary>
  
  ```YAML
name: Main workflow
on: push
jobs:
  Build:
    runs-on: ubuntu-latest
    container: gradle:6-jdk11
    steps:
      - name: Clone down repository
        uses: actions/checkout@v4       
      - name: Build application
        run: ci/build-app.sh
      - name: Test
        run: ci/unit-test-app.sh

  ```

</details>

## Results 

If the exercise is completed correctly. The output of `Test` step will look like: 

``` bash
> Task :compileJava UP-TO-DATE
> Task :processResources UP-TO-DATE
> Task :classes UP-TO-DATE

> Task :compileTestJava
Note: Creating bean classes for 1 type elements

> Task :processTestResources NO-SOURCE
> Task :testClasses
> Task :test

Deprecated Gradle features were used in this build, making it incompatible with Gradle 7.0.
Use '--warning-mode all' to show the individual deprecation warnings.
See https://docs.gradle.org/6.9.4/userguide/command_line_interface.html#sec:command_line_warnings

BUILD SUCCESSFUL in 6s
4 actionable tasks: 2 executed, 2 up-to-date
```


Great, now you have a pipeline that builds and tests your application :tada:
