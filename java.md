# Java notes

## Project layout

Root contains:

- Read me
- Cloud Foundry application manifest
- IDE project files: `<project-name>.iml` and `.idea/` folder for IntelliJ
- Build files: `pom.xml` for Maven, `build.gradle` for Gradle
- Maven must be installed locally
- Gradle can be installed locally, or the wrapper can be committed to the project: `gradlew`, 
`gradlew.bat` and `gradle/` folder

Source code is under `src/`:
```
└── src
    ├── main
    │   ├── java
    │   └── resources
    └── test
        ├── java
        └── resources
```

The folder structure in `java` is based on the package name, which is formed of
organisation name in reverse order, followed by project and package names
e.g. `io.pivotal.<project>.<package>`:

```
java
└── io
    └── pivotal
        └── <project>
            └── <package>
```

Output of `gradle bootRepackage` is under `build/`, for example:

```
build
├── classes  (Source Java classes and resources)
├── dependency-cache
├── libs  (Packaged JAR files)
└── tmp
```

Output of `mvn package` is under `target/`, for example:

```
target/
├── classes  (Source Java classes and resources)
├── generated-sources
├── generated-test-sources
├── maven-archiver
├── maven-status
├── PROJECT-VERSION.BUILD-SNAPSHOT.jar  (Packaged JAR files)
├── PROJECT-VERSION.BUILD-SNAPSHOT.jar.original
├── surefire-reports  (Test output files)
└── test-classes  (Source test classes)
```

## Entry point

Every Java project has a `main` method as it's entry point. For example:

```
public class Application {
    public static void main() {
      ...
    }
}
```
