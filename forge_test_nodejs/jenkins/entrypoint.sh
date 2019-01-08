#!/bin/sh
cd /sbin/

./add-user.sh &

java -jar /opt/jenkins.war


exit 0

