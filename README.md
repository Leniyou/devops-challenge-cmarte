
# DevOps Challenge - Junior Level

This is the documentation for DevOps Challenge - Junior Level at GBH. This documentation provides a brief description of the Challenge and instructions on how to run the scripts to complete the tests.


by - Carlos Marte

## Table of content
- Tests
- Part 1 - Applications configuration script
- Part 2 - Task automation
- Issues found
- Documentation and References

## Tests

The Challenge consists of two tests. Configure a *Sample Node.js App* that has two *Demo Apps* (demo-api & demo-webapp) and to deploy that Sample App on a local o remote VM using Ansible.

Part 1 is about creating script(s) than can configure that *Sample App* from scratch.

Part 2 relies on using Ansible Playbook to automate the processes described in the scripts of the Part 1 and leave the Sample App configured and running on a remote server.


## Part 1 - Applications configuration script

Create a script (or various scripts) that can configure a sample application from scratch.

For this part of the test I created 3 scripts that will do the configuration process. I used shell scripting:

```bash
apps-config-script.sh
set-demo-api.sh
set-demo-webapp.sh
```

**apps-config-script.sh** 

This is the main script. It will run the *yum* commands to install the necessary packages for the project such as: Node.js, npm and git, it creates the working directory project and also install "pm2 process manager package" for runing both demo apps at the same time.

For running this script you just need to open a terminal/shell and type:
> bash apps-config-script.sh


The *Demo Apps* are 2 sample nodejs apps, one is an API and the other is the WebApp-Client. As the WebApp-Client app needs to fetch data from API app, API app must be runing first in order to WebApp-Client to work correctly. I searched for a way to do that and I found pm2 process manager. I it used to run every app individually but at the same time (in the Issues section I will talk more about what I mean)

**set-demo-api.sh**

This is the script that handles the cloning process from git repository and install all dependencies for building and running the demo-api app.

This script uses this command to start demo-api in backgroud:

> pm2 start --name demo-api -p 3001 app.js

**set-demo-webapp.sh**

This is the script that handles the cloning process from git repository and install all dependencies for build and run the demo-webapp app.

This script uses this command to start demo-webclient in backgroud:

> pm2 start --name demo-webapp -p 3000 ./src/App.js

Essentially this script has the same purpose of *set-demo-api.sh*. I would have done just one script to run all task but I decided to keep things simple, and besides working on two separate scripts gives you more flexity and easy troubleshooting.

Further information about how scripts works is provided as *comments* inside every scripts.


## Part 2 - Task automation
Create an Ansible playbook that executes the same activities as in your application configuration scripts. In other words, create a playbook to deploy the applications you configured in your Part 1!

For this task I created directory structure:

```
| playbooks
| |_playbook.yaml
| roles
| |_demo-api
|   |_tasks
|     |_demo-api.yaml
|     |_main.yml
| |_demo-webapp
|   |_tasks
|     |_demo-webapp.yaml
|     |_main.yml
| |_install_packages
|   |_tasks
|     |_install_packages.yaml
|     |_main.yml
| ansible.cfg
| hosts.yaml
```

**ansible.cfg**

This file has all configuration parameters for ansible. By default ansible will use the configuration files in /etc/ansible but with this ansible.cfg file you can specify where the main files are. For example, I changed the inventory and roles default files to use the ones I have on this directory.

```
inventory = ./hosts
roles_path = ./roles
```

**hosts.yaml**
I used the hosts.yaml file to specify the connection parameters to my local virtual machine. The file contains:

```
- hostname
- ansible_connection
- ansible_port
- ansible_user
```


### playbooks directory
Contains the main playbook to run the automation process.

**playbook.yaml**
This is the file that run the automation process. It will call for the .yaml files in charge of every process.

```
- host: devopschanllenge
  roles
    - install_packages
    - demo-api
    - demo-webapp
```
For example to install necessary packages it will search in directory:

> roles > install_packages > tasks > main.yml

### roles directory

```
roles
|_demo-api
|   |_tasks
|     |_demo-api.yaml
|     |_main.yml
|_demo-webapp
|   |_tasks
|     |_demo-webapp.yaml
|     |_main.yml
|_install_packages
|   |_tasks
|     |_install_packages.yaml
|     |_main.yml
```
Contains the proper directory for every automation process, i.e. demo-api directory contains the proper .yaml files to clone, configure and install demo-api app.

Every role > tasks sub directories has the same purpose and basically the .yaml files in this sub directory are called by playbook.yaml

### roles / demo-api directory 

demo-api directory contains the proper tasks and .yaml files to clone, configure and install demo-api app.

**demo-api.yaml**

This file handles the process of cloning demo-api from github, configure .env file, install dependecies and starting the app.

To start the app the command is:

> pm2 reload --name demo-api -p 3001 app.js

I used pm2 to run the app in background

**main.yml**

This file executes a call to *demo-api.yaml* file and gives it root privileges to run the task as a power user.

### roles / demo-webapp directory 

demo-webapp directory contains the proper tasks and .yaml files to clone, configure and install demo-api app.

**demo-webapp.yaml**

This file handles the process of cloning demo-web app from github, configure .env file, install dependencies, building and starting the app.

To start the app the command is:

> pm2 reload --name demo-webapp -p 3000 ./src/App.js

I used pm2 to run the app in background

**main.yml**

This file executes a call to *demo-webapp.yaml* file and gives it root privileges to run the task as a power user.

### roles / install_packages directory

install_packages directory contains the proper tasks and .yaml files to install the required packages for the project. For example, the server must have nodejs installed before we can run the project. 

**install_packages.yaml**

This file install all required packages for running the project. It will install:

- EPEL-repository - to install nodejs from
- Node.js
- NPM
- GIT
- pm2 package manager - for running apps on background


**main.yml**

This file executes a call to *install_packages.yaml* file and gives it root privileges to run the task as a power user.

## Issues found

My first issue with this project was to run the demo apps at the same time. At the beginning I used the "&" like this:

> sh ../set-demo-api.sh & sh ../set-demo-webapp.sh

And it works, but output was a little bit messy and I didn't understand a thing! So searching on ways how to do that I ran into *pm2 package manager*. It was a little confused at the beggining but after testing some times I finally got it.

My second great issue was to work with Ansible, I haven't used it before and it has a huge documentation that you can feel overwhelmed.

I know this documentation is poor and it could be better, but trust me I did my best to understand, apply best practice and make a working project.

## Documentation and references

- [PM2 Quick Start](https://pm2.keymetrics.io/docs/usage/quick-start/)
- [Ansible Concepts](https://docs.ansible.com/ansible/latest/user_guide/basic_concepts.html)
- [Getting Started with Ansible](https://docs.ansible.com/ansible/latest/getting_started/index.html)
- [Intro to Playbooks](https://docs.ansible.com/ansible/latest/user_guide/playbooks_intro.html)
- [Ansible Docs Best Practices](https://docs.ansible.com/ansible/2.8/user_guide/playbooks_best_practices.html)