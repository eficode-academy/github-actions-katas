## Pipeline with Dockerfile

Up until now, we have only made sure that Github Actions can reach the configuration file, but not really made it do anything useful related to our actual code.

As a next step, we want Github Actions to actually clone our project, build the code and run the tests.

### Tasks

* Instead of using the image `alpine:3.7`, we now want to use a docker image that has both JDK and Gradle installed. In the image section, replace the alpine image with `gradle:jdk11`
* Under the `steps` part, add a `- checkout` list item to the list before the existing ` - run:` item.
* Change the `run` command from the multi-line linux bash script to just run `ci/build-app.sh` as the command.
* Commit and push the changes. CircleCI should automatically detect your new commit and build again. See that the build runs green and outputs this in the step log:

```bash
gradle test

Welcome to Gradle 5.3!

Here are the highlights of this release:
 - Feature variants AKA "optional dependencies"
 - Type-safe accessors in Kotlin precompiled script plugins
 - Gradle Module Metadata 1.0

For more details see https://docs.gradle.org/5.3/release-notes.html

Starting a Gradle Daemon (subsequent builds will be faster)
> Task :compileJava
> Task :processResources NO-SOURCE
> Task :classes
> Task :compileTestJava
> Task :processTestResources NO-SOURCE
> Task :testClasses
> Task :test

BUILD SUCCESSFUL in 6s
3 actionable tasks: 3 executed

```

Congratulations, you have now run the tests in your code!