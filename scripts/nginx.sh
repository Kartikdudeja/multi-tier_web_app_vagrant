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

logger "Nginx Installation started"

logger "Installing required Packages..."
sudo yum update -y
sudo yum install epel-release nginx -y

logger "starting & enabling nginx"
systemctl start nginx
systemctl enable nginx

logger "creating conf file for proxy"
cp /vagrant/config/vproapp.conf /etc/nginx/conf.d

logger "restarting nginx service"
systemctl restart nginx

logger "setting up firewalld"  
systemctl start firewalld && systemctl enable firewalld
firewall-cmd --permanent --add-service=http
firewall-cmd --permanent --add-service=https
firewall-cmd --reload

logger "Nginx Installation completed"