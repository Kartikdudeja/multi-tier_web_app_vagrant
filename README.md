# Multi-Tier Web App Deployment with Vagrant

## Overview

This repository contains the necessary files and instructions to deploy a multi-tier web application using Vagrant. This Project's architecture comprises Tomcat serving as the Application Level, MySQL handling the Database Layer, Memcached responsible for Caching, RabbitMQ for Asynchronous Processing, and Nginx acting as the Web-Proxy. Vagrant will help us create and manage virtual machines to simulate these tiers locally for development and testing purposes.

This Web Application utilizes Vagrant for Infrastructure setup, and Bash Scripts for Automated Installation, Configuration, and Deployment, streamlining the automation and deployment processes.

## Prerequisites

Before getting started, ensure that you have the following software installed on your system:

1. [Vagrant](https://www.vagrantup.com/downloads.html)
2. [VirtualBox](https://www.virtualbox.org/wiki/Downloads)

## Project Structure:

The repository is organized as follows:

```
multi-tier_web_app_vagrant/
│
├── Vagrantfile (IaC)
|
├── scripts/ (deployment scripts)
│   ├── memcache.sh (deploy Memcached service)
|   ├── mysql.sh (install, setup and configure database on db host)
|   ├── nginx.sh (install and configure nginx service)
|   ├── rabbitmq.sh (install and configure rabbitmq service)
|   └── tomcat.sh (install and configure tomcat service, generate artifact using maven and deploy on tomcat)
|
└── config/ (configuration files)
    ├── application.properties (java web app configuration file)
    └── vproapp.conf (nginx config file)
```

* `Vagrantfile`: This file defines the required virtual machines for the project. During provisioning, it also executes the Bash Script to deploy the Application Stack.
* `scripts/`: This directory contains Bash Scripts responsible for the installation, configuration, and deployment of various components of the Web Application.
* `config/`: Inside this directory, you can find the application configuration and nginx configuration files.

Note:
- The application uses the hostname defined in `application.properties` to connect and identify other machines. If you modify the hostname in the `Vagrantfile`, make sure to update it in the config file accordingly.
- Vagrant relies on the sync folder to locate the Bash Scripts. If you change the project structure, ensure to update the path to scripts in the `Vagrantfile`.

## Getting Started

1. Clone this repository to your local machine:

```bash
git clone https://github.com/Kartikdudeja/multi-tier_web_app_vagrant.git
cd multi-tier_web_app_vagrant
```

2. Configure the Vagrant environment:

   - Open the `Vagrantfile` in the project root and adjust the virtual machine settings (CPU, memory, etc.) according to your system resources.
   - Update any network configurations (if necessary) for communication between the tiers.

3. Start the virtual machines:

```bash
vagrant up
```

4. Access the Web Application:  
   Visit the IP of nginx VM to access the Web Application, `http://192.168.20.15`

## Troubleshooting

If you encounter any issues during the setup process, check deployment script logs. Script logs are located at `/tmp/script.log`.

1. Login to the Virtual Machine
``` bash
vagrant ssh [machine-name]
```

2. Read Logs
``` bash
less /tmp/script.log
```

## Vagrant Commands

Here are some useful Vagrant commands to manage the virtual machines:

- `vagrant up`: Create and provision the virtual machines.
- `vagrant halt`: Gracefully shut down the virtual machines.
- `vagrant destroy`: Remove the virtual machines. This will delete all data inside the virtual machines, so use with caution.
- `vagrant ssh [machine-name]`: SSH into a specific virtual machine.

## Important Notes

- This setup is for development and testing purposes only. For production deployment, you should use appropriate cloud services or physical servers with proper security measures in place.
- Make sure to configure firewall rules and security settings properly to restrict access to your virtual machines as needed.
- Remember to backup your data if necessary, especially before running `vagrant destroy`.

## Contributing

If you find any issues with this setup or have suggestions for improvements, feel free to open an issue or submit a pull request.

## Acknowledgments

I want to express my gratitude to the open-source community for providing the tools and libraries that made this multi-tier web app possible.

