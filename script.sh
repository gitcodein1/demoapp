#!bin/bash
VERSION=$(mvn -q \
        -Dexec.executable=echo \
        -Dexec.args='${project.version}' \
        --non-recursive \
        exec:exec)

echo "Pull Base Image From Proxy Repo"
docker pull ecf8-183-87-250-107.ngrok-free.app/tomcat:alpine

echo "Tag the Pulled Image"
docker tag ecf8-183-87-250-107.ngrok-free.app/tomcat:alpine tomcat:alpine

if [[ $VERSION =~ ^[0-9]+.[0-9]+.[0-9]+-SNAPSHOT ]]
then
    echo "Build Image"
    docker build -t b16a-183-87-250-107.ngrok-free.app/demoapp:$VERSION .

    echo "Login To Docker Registry"
    echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin b16a-183-87-250-107.ngrok-free.app
    
    echo "Push Docker Image"
    docker push b16a-183-87-250-107.ngrok-free.app/demoapp:$VERSION

    echo "Remove Image"
    docker rmi b16a-183-87-250-107.ngrok-free.app/demoapp:$VERSION

else
    echo "Build Image"
    docker build -t 21d6-183-87-250-107.ngrok-free.app/demoapp:$VERSION .
    
    echo "Login To Docker Registry"
    echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin 21d6-183-87-250-107.ngrok-free.app

    echo "Push Docker Image"
    docker push 21d6-183-87-250-107.ngrok-free.app/demoapp:$VERSION

    echo "Remove Image"
    docker rmi 21d6-183-87-250-107.ngrok-free.app/demoapp:$VERSION
fi

docker rmi ecf8-183-87-250-107.ngrok-free.app/tomcat:alpine tomcat:alpine
