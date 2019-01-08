#!/bin/bash

while true; do
    RES=$(java -jar $JENKINS_HOME/war/WEB-INF/jenkins-cli.jar -s http://localhost:8080/ groovy $JENKINS_HOME/user.groovy 2>&1)
    if [ -z "$RES" ];then
        break;
    fi
    sleep 1
done
