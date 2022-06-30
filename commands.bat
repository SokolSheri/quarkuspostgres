@ECHO off
SET /p inputCommand="What command would you like to run - 1 for local-server, 2 for push-to-rosa, 3 for create-native, 4 for create-jvm "
If %inputCommand%==1 echo "local-server deployment started"
If %inputCommand%==2 echo "pushing to rosa"
If %inputCommand%==3 echo "creating native build"
If %inputCommand%==4 echo "create jvm image"
If %inputCommand%==1 call ./gradlew quarkusDev
If %inputCommand%==2 call ./gradlew build -D quarkus.kubernetes.deploy=true
If %inputCommand%==3 call ./gradlew build -D quarkus.package.type=native -D quarkus.native.container-build=true -D quarkus.native.builder-image=quay.io/quarkus/ubi-quarkus-native-image:21.3-java17
If %inputCommand%==4 call ./gradlew quarkusDev
