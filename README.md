# quarkus-bootstrap Project

Run the following commands to build and run the application :
```shell script
  gradle build -x checkstyleMain   
```
```shell script
  java -jar build/quarkus-app/quarkus-run.jar
```

This project uses Quarkus, the Supersonic Subatomic Java Framework.

If you want to learn more about Quarkus, please visit its website: https://quarkus.io/ .

## Running the application in dev mode

You can run your application in dev mode that enables live coding using:
```shell script
./gradlew quarkusDev
```

> **_NOTE:_**  Quarkus now ships with a Dev UI, which is available in dev mode only at http://localhost:8080/q/dev/.

## Packaging and running the application

The application can be packaged using:
```shell script
./gradlew build
```
It produces the `quarkus-run.jar` file in the `build/quarkus-app/` directory.
Be aware that it’s not an _über-jar_ as the dependencies are copied into the `build/quarkus-app/lib/` directory.

The application is now runnable using `java -jar build/quarkus-app/quarkus-run.jar`.

If you want to build an _über-jar_, execute the following command:
```shell script
./gradlew build -Dquarkus.package.type=uber-jar
```

The application, packaged as an _über-jar_, is now runnable using `java -jar build/*-runner.jar`.

## Creating a native executable

#### Windows: 

##### Prerequisite - 
1. Install GralVM [https://github.com/graalvm/mandrel/releases]
2. Microsoft Dev Tools for C++ [https://aka.ms/vs/15/release/vs_buildtools.exe]  

#### Configure Environment variable - 
1. Set GRAALVM_HOME to GraalVM Installation directory.
2. Set JAVA_HOME to GraalVM Installation directory.
3. Set Path to include bin directories of GraalVM like %GRAALVM_HOME%\bin
4. Set Path to include bin directories of Java like %JAVA_HOME%\bin
5. Install the **native-image** tool using **gu install native-image**:
6. Open console using CMD and Go to C:\Program Files (x86)\Microsoft Visual Studio\2017\BuildTools\VC\Auxiliary\Build directory.
7. Initialize Microsoft Native Tools for Visual Studio before packaging. Execute **vcvars64.bat** for this. 


Now you can create a native executable using: 
```shell script
./gradlew build -Dquarkus.package.type=native
```

Or, if you don't have GraalVM installed, you can run the native executable build in a container using: 
```shell script
./gradlew build -D quarkus.package.type=native -D quarkus.native.container-build=true -D quarkus.native.builder-image=quay.io/quarkus/ubi-quarkus-native-image:21.3-java17
```

You can then execute your native executable with: `./build/storage-1.0.0-SNAPSHOT-runner`

Reference - https://quarkus.io/guides/building-native-image#configuring-graalvm 

If you want to learn more about building native executables, please consult https://quarkus.io/guides/gradle-tooling.


## Podman Installation

##### Step 1: Install Ubuntu on a windows machine
1. Open Powershell
2. Execute wsl --install -d ubuntu

##### Step 2: Setup username and password
1. Complete Step 1.
2. Open the ubuntu machine and set the Username and password

##### Step 3: Login to Ubuntu machine
1. Open Powershell and run **wsl** command.
2. Execute **sudo su**.
3. Enter the password when prompted.

##### Step 4: Install Podman in Ubuntu Machine. 
1. Execute **./etc/os-release**
2. Execute **echo "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_${VERSION_ID}/ /" | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list**
3. Execute **curl -L "https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_${VERSION_ID}/Release.key" | sudo apt-key add -**
4. **sudo apt install ca-certificates**
5. **sudo apt update**
6. **sudo apt -y install podman**

#### Alternatively, install podman in a dedicated WSL distribution with a native Windows executable that communicates with this distribution:

1. Download Podman's Window Installer [https://github.com/containers/podman/releases/download/v4.1.1/podman-v4.1.1.msi]
2. Open command prompt using **cmd**
3. Execute **wsl --set-default-version 2**
4. Execute **podman machine init**
5. Execute **podman machine start**

#### Reference Links - 
1. https://github.com/containers/podman/blob/main/docs/tutorials/podman-for-windows.md
2. https://www.redhat.com/sysadmin/run-podman-windows


## Run Postgres database locally inside container. 

#### Instructions:
1. Set up podman to run in Windows using instructions provided in **Podman Installation**.
2. Fetch the image as follows (Use the full image name to avoid “_Error: short-name resolution enforced but cannot prompt without a TTY_")
```
podman pull docker.io/library/postgres:latest
```
3. There are then two options for where the data is stored, you can either get podman to create a volume or you can specify an existing windows folder.

#### Option 1: Get podman to create the Volume
      Use the following command to run the image:
```
podman run --name postgresql -e POSTGRES_USER=admin -e POSTGRES_PASSWORD=Password -p 5432:5432 -v postgresql:/var/lib/postgresql/data -d postgres
```
The postgresql after -v is the volume name. You can find the location of the volume using:
```
podman volume inspect postgresql
```
You can browse the volume from windows by using **\\wsl$\podman-machine-default** in explorer.

#### Option 2: Create a regular Windows folder
      Using this approach we found various permission issues. The best way to avoid these is to create the folder from within the podman distribution. To do this connect to the distribution as follows:
```
podman machine ssh
```
Then navigate to the parent folder under **/mnt/c** and create the folder using **mkdir (do not use sudo)**.

You can then exit from the podman shell and run the image as follows:
```
podman run --name postgresql -e POSTGRES_USER=admin -e POSTGRES_PASSWORD=Password -p 5432:5432 -v /mnt/c/data/postgresql:/var/lib/postgresql/data -d postgres 
```
Where the postgresql folder was created in **C:\data (/mnt/c/data)**.


#### PostgreSql **Database Configuration**
For local environment set-up, check application.properties file.

#### Liquibase Configuration
Basic liquibase commands are:

1. For deploying the changelog file to the configured database
```
./gradlew update
```
2. For Rollback the database state to database version 1.0.0. (here, liquibaseCommandValue will define the database tag value).
```
./gradlew rollback -PliquibaseCommandValue="1.0.0"  
```
3. After deploying the changes, add a new database version with tag. (here, liquibaseCommandValue will define the database tag value).
```
./gradlew tag -PliquibaseCommandValue="v_2.0" -
```
4. Generate the Changelog from the configured database.
```
./gradlew generateChangeLog
```
For More tasks related to liquibase, run command:
```
./gradlew tasks
```

## Related Guides

- OpenShift ([guide](https://quarkus.io/guides/deploying-to-openshift)): Generate OpenShift resources from annotations
- RESTEasy JSON-B ([guide](https://quarkus.io/guides/rest-json)): JSON-B serialization support for RESTEasy
- SmallRye OpenAPI ([guide](https://quarkus.io/guides/openapi-swaggerui)): Document your REST APIs with OpenAPI - comes with Swagger UI
- RESTEasy JAX-RS ([guide](https://quarkus.io/guides/rest-json)): REST endpoint framework implementing JAX-RS and more
- SmallRye Health ([guide](https://quarkus.io/guides/microprofile-health)): Monitor service health

## Provided Code

### gRPC

Create your first gRPC service

[Related guide section...](https://quarkus.io/guides/grpc-getting-started)

### RESTEasy JAX-RS

Easily start your RESTful Web Services

[Related guide section...](https://quarkus.io/guides/getting-started#the-jax-rs-resources)

### SmallRye Health

Monitor your application's health using SmallRye Health

[Related guide section...](https://quarkus.io/guides/smallrye-health)

### Linting Link
 https://github.com/nebula-plugins/gradle-lint-plugin/wiki


