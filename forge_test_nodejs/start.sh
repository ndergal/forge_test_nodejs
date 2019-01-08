#!/bin/bash
set -e

if [ "$(id -u)" != "0" ] ; then #if the user is not root
    echo "You should be root to use this script."
    exit 1
fi

############################################################ checking option #####################################################################
function checkerror(){
    RESULT=$1
    if [ $RESULT -eq 0 ];then
        echo "Everything went ok."
    else
        echo "Error exit code $RESULT."
        exit $RESULT
    fi

}

function usage(){
    printf "\nSCRIPT USAGE :\n\n"

    printf "COMMANDS :\n\n"
        printf "\tstart : Launch the forge with hook.\n"
        printf "\tstart2 : Launch the forge.\n"
        printf "\tstop : Stop the forge.\n" 
        printf "\trestart : Restart the forge.\n"  
        printf "\thelp : Show this message.\n\n\n\n"

    printf "ENVIRONMENT VARIABLES :\n\n"
        printf "\tIt is possible to set environment variables to customize the installation.\n"
        printf "\tOn default those environment variables are:\n\n"
            printf "\t\tlog_in = valilab \n"
            printf "\t\tpassword = rootroot \n"
            printf "\t\tname = admin \n"
            printf "\t\tlastname = forge \n"
            printf "\t\taddress = admin@ign-forge.fr \n"
            printf "\t\tproxy = \n\n\n\n"


printf "INSECURE REGISTRY : "
    printf "To pull some images used for this forge you need to add configuration lines in order to add our internal insecure-registry.\n\n"
    printf "\tIf your system is USING systemd add the following line in \"/etc/systemd/system/docker.service.d/settings.conf\":\n\n"
    printf "\t\tExecStart=/usr/bin/docker daemon -H fd:// \$OPTIONS --insecure-registry valilabis.ensg.eu:5000\n\n"

    printf "\tIf your system is NOT USING systemd add the following line in \"/etc/default/docker\":\n\n"
    printf "\t\tDOCKER_OPTS=\"--insecure-registry valilabis.ensg.eu:5000\"\n\n\n\n"

printf "PROXY : If you are using a proxy.\n\n"
    printf "\tIf your system is USING systemd add the following line in \"/etc/systemd/system/docker.service.d/settings.conf\":\n\n"
    printf "\t\tEnvironment=\"HTTP_PROXY=<PROXY_ADDRESS>\" \"HTTPS_PROXY=<PROXY_ADDRESS>\" \"NO_PROXY=127.0.0.1/16, 172.31.0.0/16, ::1, valilabis.ensg.eu, valilabis.ensg.eu/5000\"\n\n"

    printf "\tIf your system is NOT USING systemd add the following line in \"/etc/default/docker\":\n\n"
    printf "\t\texport http_proxy=\"<PROXY_ADDRESS>\"\n"
    printf "\t\texport https_proxy=\"<PROXY_ADDRESS>\"\n"
    printf "\t\texport no_proxy=\"127.0.0.1/8,172.31.0.0/16,::1,valilabis.ensg.eu, valilabis.ensg.eu:5000\"\n\n\n\n"


    printf "RETURN VALUES :\n\n"    
    printf "\tThis script returns 1 if bad or no arguments are given or 0 if everything went well.\n\n"
}

function start(){
    echo "Launching the forge.."
    docker-compose up -d
    checkerror $?
}

function start2(){
    echo "Launching the forge.."
    docker-compose -f docker-compose2.yml up -d
    checkerror $?
}

function stop(){
    echo "Stopping the forge.."
    docker-compose stop
    checkerror $?
}

function restart(){
    echo "Restarting the forge.."
    docker-compose restart
    checkerror $?
}

function remove(){
    echo "Removing the forge.."
    docker-compose rm
    checkerror $?
}

case "$1" in 
    start)   start ; exit 0;;
    start2)  start2; exit 0;;
    stop)    stop ; exit 0;;
    restart) restart; exit 0;;
    remove)  remove; exit 0;;
    help)    usage; exit 0;;
    *)       usage; exit 1;;
esac
