# Java Confidential Hello World!

In this tutorial, we reproduce the same steps performed in the [Scone Mesh Tutorial](https://sconedocs.github.io/scone_mesh_tutorial/) to show how to provide a simple cloud-native Java application with a secret such that **nobody** (except for the program itself) can access the secret. 

## Java Support

Currently, we offer support for the Java versions ([open JDK](https://openjdk.org/)) listed below. To select a Java version, please specify it using the field `build.kind` in the `service.yaml.template` file.  
- Java 17: kind `java` 
- Java 15: kind `java15`
- Java 8: kind `java8`

## Declaring an Application

Your Java application should be declared as a `build` object in the `service.yaml` file. You *must* specify all files required for running your application as entries in `build.copy`. That includes `JARs` used as dependencies. 

The classpath, if not provided in `build.command` (`java -cp <classpath> ...` or `java -classpath <classpath> ...`), is built up automatically and injected right after the keyword `java` in `build.command`. It is formed taking into account `build.pwd` (your application home), and all `JARs` files listed in `build.copy`. 

> **NOTE:** You only need to list in the copy section `*.java` and `*.jar` files. Your application will be compiled automatically.

> **NOTE:** As of now, `*.zip` files are not supported as part of an automatically built classpath.

### Simple Example with Dependencies

Suppose you have been working on a project containing the following structure:

```
javaapp
│   service.yaml
└───lib
│   │   dependency.jar
│   
└───main
│   │
│   └───java
│       │   Main.java
│       └───package
│           │   SomeClass.java
```
The structure above can be declared as follows.

```
build:
   name: java-new-app
   kind: java
   to: $REGISTRY/java_new_app:1
   pwd: /java
   command: java main.java.Main
   copy:
      - main/java/Main.java
      - main/java/package/SomeClass.java
      - lib/dependency.jar
   signature:
      sign: true
```

> **NOTE:** As of now, a structured project *must* follow a `main.java.*` structure in which `main` is placed at the root folder of the project as shown in the example above. Of course, you can also place all files in the root folder of your project project, if you like. 
