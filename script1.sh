#!bin/bash
VERSION=$(mvn -q \
        -Dexec.executable=echo \
        -Dexec.args='${project.version}' \
        --non-recursive \
        exec:exec)

proxy_repo="9211-183-87-250-107.ngrok-free.app"
snapshot_repo="afad-183-87-250-107.ngrok-free.app"
release_repo="f900-183-87-250-107.ngrok-free.app"


docker login -u $user -p $pass $proxy_repo
echo "**Pull Base Image From Proxy Repo**"
docker pull $proxy_repo/tomcat:alpine
echo
echo "**Tag the Pulled Image**"
docker tag $proxy_repo/tomcat:alpine tomcat:alpine
echo
docker logout

if [[ $VERSION =~ ^[0-9]+.[0-9]+.[0-9]+-SNAPSHOT ]]
then
    echo "--------------------------"
    echo "* SNAPSHOT REPO SELECTED *"
    echo "--------------------------"
    echo ">> Build Image <<"
    echo "-----------------"
    docker build -t $snapshot_repo/demoapp:$VERSION .
    echo
    echo ">>Login To Docker Registry..."
    echo "-----------------------------"
    docker login -u $user -p $pass $snapshot_repo
    echo
    echo ">> Push Docker Image <<"
    echo "-----------------------"
    docker push $snapshot_repo/demoapp:$VERSION
    echo
    echo ">> Remove Image <<"
    echo "------------------"
    docker rmi $snapshot_repo/demoapp:$VERSION

else
    echo "-------------------------"
    echo "* RELEASE REPO SELECTED *"
    echo "-------------------------"
    echo ">> Build Image <<"
    echo "-----------------"
    docker build -t $release_repo/demoapp:$VERSION .
    echo
    echo ">> Login To Docker Registry <<"
    echo "-------------------------------"
    docker login -u $user -p $pass $release_repo_repo
    echo
    echo ">> Push Docker Image <<"
    echo "-----------------------"
    docker push $release_repo/demoapp:$VERSION
    echo
    echo ">> Remove Image <<"
    echo "------------------"
    docker rmi $release_repo/demoapp:$VERSION
fi

echo
echo ">> Clean UP <<"
echo "--------------"
docker rmi $proxy_repo/tomcat:alpine tomcat:alpine
echo
