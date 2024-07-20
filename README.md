# Java Confidential Hello World!

## TL'DR

```bash
# In case you want to test a release candidate of `sconectl`, you can change the repo and the VERSION
export SCONECTL_REPO=registry.scontain.com/cicd # default is registry.scontain.com/sconectl
export VERSION=5.8.0  # default version is "latest".
export CAS="cas" # set the name of the CAS instance that we should used; default is "cas"
export CAS_NAMESPACE="scone-system" # set the Kubernetes namespace of the CAS instance that we should used; default is "default"
# if you want to use the latest stable release, ensure that these variables are not set:
unset SCONECTL_REPO
unset VERSION
# cleanup the last state
rm -rf release.sh target
# define REPO to which you are # define REPO to which you are permitted to push container images
REPO="<YOUR-REPO>"
# execute all steps of this tutorial
./run.sh -i "$REPO" --release java-app -v
```

## Motivation

In this tutorial, we reproduce the same steps performed in the [Scone Mesh Tutorial](https://sconedocs.github.io/scone_mesh_tutorial/) to show how to provide a simple cloud-native Java application with a secret such that **nobody** (except for the program itself) can access the secret.

The code of this tutorial can be found [on github](https://github.com/scontain/java_sconectl_tutorial/).

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

```text
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

```text
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
