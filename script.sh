#!bin/bash
VERSION=$(mvn -q \
        -Dexec.executable=echo \
        -Dexec.args='${project.version}' \
        --non-recursive \
        exec:exec)
                        
if [[ $VERSION =~ ^[0-9]+.[0-9]+.[0-9]+-SNAPSHOT ]]
then
    echo "docker build -t demoapp:snapshot"
else
    echo "docker build -t demoapp:release"
fi
