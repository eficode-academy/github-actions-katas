## Pipeline with Dockerfile

Up until now, we have only made sure that Github Actions can reach the configuration file, but not really made it do anything useful related to our actual code.

As a next step, we want Github Actions to actually clone our project, build the code and run the tests.

### Tasks

* Instead of printing "Hello World!", we now want to use a docker image that has both JDK and Gradle installed. After section `runs-on:` add `container: gradle:jdk11`
* Under the `steps` part, add a `- uses:` list item to the list before the existing ` - run:` item with action: `actions/checkout@v2`

* Change the `run` command from the multi-line linux bash script to just run `ci/build-app.sh` as the command. In case of issues with access denied add `chmod +x ci/build-app.sh`.
* Commit and push the changes. Github Actions should automatically detect your new commit and build again. See that the build runs green and outputs this in the step log:

```bash
Run ./ci/build-app.sh

Welcome to Gradle 6.9!

Here are the highlights of this release:
 - This is a small backport release.
 - Java 16 can be used to compile when used with Java toolchains
 - Dynamic versions can be used within plugin declarations
 - Native support for Apple Silicon processors

For more details see https://docs.gradle.org/6.9/release-notes.html

Starting a Gradle Daemon (subsequent builds will be faster)
> Task :clean UP-TO-DATE

> Task :compileJava
Note: Creating bean classes for 3 type elements

> Task :processResources
> Task :classes
> Task :shadowJar

Deprecated Gradle features were used in this build, making it incompatible with Gradle 7.0.
Use '--warning-mode all' to show the individual deprecation warnings.
See https://docs.gradle.org/6.9/userguide/command_line_interface.html#sec:command_line_warnings

BUILD SUCCESSFUL in 28s
4 actionable tasks: 3 executed, 1 up-to-date
```

Congratulations, you have now run the tests in your code!