#!/bin/bash

# logger function
logger(){

    # variables
    local LOG_FILE_PATH=/tmp
    local LOG_FILE_NAME=script.log

    if [ $# -eq 2 ]
    then
        SEVERITY="$1"
        LOG_MESSAGE="$2"
    elif [ $# -eq 1 ]
    then
        SEVERITY="INFO"
        LOG_MESSAGE="$1"
    else
        SEVERITY="EXCEPTION"
        LOG_MESSAGE="Wrong Sytax used for logger function. Usage: logger <SEVERITY> <LOG_MESSAGE>"
    fi
    
    echo -e "$(date '+%Y-%m-%d %T') $SEVERITY: $LOG_MESSAGE" >> $LOG_FILE_PATH/$LOG_FILE_NAME

}

logger "Memcache Installation started"

logger "Installing required Packages..."
sudo yum install epel-release memcached -y

logger "starting & enabling memcached"
sudo systemctl start memcached
sudo systemctl enable memcached

logger "setting up tcp port for memcached communication"
sudo memcached -p 11211 -U 11111 -u memcached -d

logger "Memcache Installation completed"