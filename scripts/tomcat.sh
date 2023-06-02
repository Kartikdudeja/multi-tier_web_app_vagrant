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

logger "Tomcat Installation started"

TOMURL="https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.37/bin/apache-tomcat-8.5.37.tar.gz"

logger "Installing required Packages..."
yum install java-1.8.0-openjdk -y
yum install git maven wget -y

logger "download and setting up tomcat..."
cd /tmp/
wget $TOMURL -O tomcatbin.tar.gz
EXTOUT=`tar xzvf tomcatbin.tar.gz`
TOMDIR=`echo $EXTOUT | cut -d '/' -f1`
useradd --shell /sbin/nologin tomcat
rsync -avzh /tmp/$TOMDIR/ /usr/local/tomcat8/
chown -R tomcat.tomcat /usr/local/tomcat8

logger "deamonizing tomcat service"
rm -rf /etc/systemd/system/tomcat.service

cat << EOT > /etc/systemd/system/tomcat.service
[Unit]
Description=Tomcat
After=network.target

[Service]
User=tomcat
Group=tomcat
WorkingDirectory=/usr/local/tomcat8
Environment=JRE_HOME=/usr/lib/jvm/jre
Environment=JAVA_HOME=/usr/lib/jvm/jre
Environment=CATALINA_PID=/var/tomcat/%i/run/tomcat.pid
Environment=CATALINA_HOME=/usr/local/tomcat8
Environment=CATALINE_BASE=/usr/local/tomcat8
ExecStart=/usr/local/tomcat8/bin/catalina.sh run
ExecStop=/usr/local/tomcat8/bin/shutdown.sh
RestartSec=10
Restart=always

[Install]
WantedBy=multi-user.target

EOT

systemctl daemon-reload

logger "starting & enabling tomcat"

logger "cloning project from repository" 
git clone -b local-setup https://github.com/devopshydclub/vprofile-project.git

logger "generating artifacts using Maven"
cd vprofile-project
mvn install
systemctl stop tomcat
sleep 60
rm -rf /usr/local/tomcat8/webapps/ROOT*
cp target/vprofile-v2.war /usr/local/tomcat8/webapps/ROOT.war
systemctl start tomcat
sleep 120

logger "copying 'application.properties' from sync directory"
cp /vagrant/config/application.properties /usr/local/tomcat8/webapps/ROOT/WEB-INF/classes/application.properties
systemctl restart tomcat

logger "Tomcat Installation completed"
