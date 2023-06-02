# Deploy a Multi-tier Web Application with Vagrant

Vagrant is a tool for building complete development environments. With an easy-to-use workflow and focus on automation, Vagrant lowers development environment setup time, increases development/production parity.

We will be deploying a Multi-tier Java Web Applicaiton, Architecture of this Project has Tomcat at the Application Level, MySQL at Database Layer, Memcached for Caching, RabbitMQ for Asyc Processing and Nginx for Proxy.

For Automation & Deployment, Vagrant is used to setup the Infrastructure and Bash Scripts for Installing, Configuring and Deployment the Components of this Web Application

## Prerequisites:
* Oracle VM VirtualBox
* Vagrant
* Vagrant Plugin: vagrant-hostmanager

<br/>

## Brief about files and directories in this Repository:

* Vagrantfile: Vagrantfile describes the Machines required for this Project also during provisioning it will execute the Bash Script to deploy the Application Stack.
* 'scripts/' Directory contains the Bash Scripts which we be performing the Installing, Configuring and Deployment the Components of this Web Application.
* 'config/' directory contains the application configuration and nginx configuration file.  

> Important Note: 
> 1. Application uses hostname defined in 'application.properties' to identify and connect to the Other Machines, do update the names in config file incase you change name in the 'Vagrantfile'.
> 2. Vagrant uses sync folder to locate the Bash Scripts, incase you change the Project Structure, do update the path to scripts in the 'Vagrantfile'.

<br/>

## Steps to Deploy the Application Stack:

Clone the Repository and ensure all Prerequisites are installed on your local machine

Run the following Command to bring up the Virtual Machines
``` bash
vagrant up --provision
```

Wait until all VM are up, once all Machines are up, check the Nginx Machine's IP in the browser to access the Website

``` bash
http://192.168.20.15/
```

<br/>

### Check Script logs, Post Completion

You can also check script logs to check on the Progress and ensure that everything is working fine fine, script logs are located at '/tmp/script.log'. To Check logs, you can use the following commands:

1. Login to the Virtual Machine
``` bash
vagrant ssh <hostname>
```

2. Read Logs
``` bash
less /tmp/script.log
```
