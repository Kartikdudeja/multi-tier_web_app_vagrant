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

DATABASE_PASS='admin123'

logger "mysql installation started"

logger "Installing required Packages..."
sudo yum update -y
sudo yum install epel-release git zip unzip mariadb-server -y

logger "starting & enabling mariadb-server"
sudo systemctl start mariadb
sudo systemctl enable mariadb

logger "cloning project from the repository..."
cd /tmp/
git clone -b local-setup https://github.com/devopshydclub/vprofile-project.git

logger "Setting up the database"
sudo mysqladmin -u root password "$DATABASE_PASS"
sudo mysql -u root -p"$DATABASE_PASS" -e "UPDATE mysql.user SET Password=PASSWORD('$DATABASE_PASS') WHERE User='root';"
sudo mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
sudo mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.user WHERE User='';"
sudo mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%';"
sudo mysql -u root -p"$DATABASE_PASS" -e "FLUSH PRIVILEGES;"
sudo mysql -u root -p"$DATABASE_PASS" -e "create database accounts;"
sudo mysql -u root -p"$DATABASE_PASS" -e "grant all privileges on accounts.* TO 'admin'@'localhost' identified by 'admin123';"
sudo mysql -u root -p"$DATABASE_PASS" -e "grant all privileges on accounts.* TO 'admin'@'%' identified by 'admin123';"
sudo mysql -u root -p"$DATABASE_PASS" accounts < /tmp/vprofile-project/src/main/resources/db_backup.sql
sudo mysql -u root -p"$DATABASE_PASS" -e "FLUSH PRIVILEGES;"

logger "restarting mariadb-server"
sudo systemctl restart mariadb

logger "starting firewall and allowing the allowing tcp traffic over 3306 port"
sudo systemctl start firewalld
sudo systemctl enable firewalld
sudo firewall-cmd --get-active-zones
sudo firewall-cmd --zone=public --add-port=3306/tcp --permanent
sudo firewall-cmd --reload
sudo systemctl restart mariadb

logger "mysql installation completed"