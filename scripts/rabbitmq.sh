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

logger "RabbitMQ Installation started"

logger "Installing required Packages..."
sudo yum update -y
sudo yum install epel-release wget -y

logger "Installing Additional Package" 
cd /tmp/
wget http://packages.erlang-solutions.com/erlang-solutions-2.0-1.noarch.rpm
sudo rpm -Uvh erlang-solutions-2.0-1.noarch.rpm
sudo yum -y install erlang socat

logger "Installing RabbitMq"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash
sudo yum install rabbitmq-server -y

logger "starting & enabling rabbitmq-server"
sudo systemctl start rabbitmq-server
sudo systemctl enable rabbitmq-server

logger "configuring rabbitmq..."
sudo sh -c 'echo "[{rabbit, [{loopback_users, []}]}]." > /etc/rabbitmq/rabbitmq.config'
sudo rabbitmqctl add_user test test
sudo rabbitmqctl set_user_tags test administrator

logger "restarting rabbitmq..."
sudo systemctl restart rabbitmq-server

logger "RabbitMQ Installation completed"