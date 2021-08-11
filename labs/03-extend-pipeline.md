## Extend pipeline 
After the application is build, the unit test should be perfommed to check if it works as expected. 

### Tasks

1. Add a step running the unit test step named `Test`, which will run the script`ci/unit-test-app.sh`.


If the exercise is complited correctly. The output of `Test`step will look like: 

```YAML
> Task :clean

> Task :compileJava
Note: Creating bean classes for 3 type elements

> Task :processResources
> Task :classes

> Task :compileTestJava
Note: Creating bean classes for 1 type elements

> Task :processTestResources NO-SOURCE
> Task :testClasses
> Task :test

Deprecated Gradle features were used in this build, making it incompatible with Gradle 7.0.
Use '--warning-mode all' to show the individual deprecation warnings.
See https://docs.gradle.org/6.9/userguide/command_line_interface.html#sec:command_line_warnings

BUILD SUCCESSFUL in 7s
5 actionable tasks: 5 executed
```


