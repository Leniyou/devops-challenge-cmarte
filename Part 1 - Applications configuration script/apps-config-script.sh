#!/bin/bash

# apps-config.script.sh

: '
 Run this script in order to complete Part 1 of the Tests - Applications configuration script 
 for DevOps Challenge - Junior Level at Soluciones GBH
 
 Go to Terminal and type: 
   sh app-config-script.sh
 
 NOTE: if you are using a UNIX-based operating system (MacOS, Ubuntu, RedHat, etc.) you must granted 
 execution permissions to script first. 
 
 You can do this by typing:
   chmod +x ./app-config-script.sh
 
 Then run the script:
   ./app-config-script.sh

 Or you simply run the script using:
   bash app-config-script.sh
 
 This script will configure a sample nodejs application that has two demo apps (Demo API and Demo WebApp Client) from scratch
  in order to do that the script needs to:

   1 - Updates current installed packages using yum update (it is a good practice)
   2 - Verify that Node.js is installed, if not then install it
   2.1 - Enables EPEL repository
   2.2 - Install Node.js and NPM
   3 - Install Git for cloning the demo apps
   4 - Install "pm2 process manager" to run both apps at the same time
   5 - Create working directories
   6 - Run set-demo-api.sh and set-demo-webapp.sh scripts to get both demo apps configure and running

'

## Task 1 - Update current installed packages ##
echo "Updating installed packages..."
sudo yum update -y
printf "\n"

## Task 2 - Verify that Node.js is installed ##
## We need to install epel-repo if we want to install node.js on CentOS 7
echo "Installing epel-repo nodejs npm..."
sudo yum install epel-release nodejs npm -y
printf "\n"

## Task 3 - Install Git ##
echo "Installing Git..."
sudo yum install git -y
printf "\n"

## Task 4 - Install "concurrently package" ##
: '
 Running two commands at the same time is possible using "& operator", example npm start & npm run watch
 but is not a good practice because you cannot see the commands outputs one by one but mixed 
 that makes hard to see if there are any errors or if one commands fails you will not notice.

 In order to make the project work we need to run two demo apps simultaneously 
 this is possibly with "pm2 package". pm2 is a daemon process manager that can be used
 to run more than one app at the same time 
 https://pm2.keymetrics.io/docs/usage/quick-start/ - for more information
'
printf "\n"
echo "Installing pm2 process manager..."
npm install pm2 -g
printf "\n"

## Task 5 - Creating directory to store our project
DIR="devops-challenge"

# If directory doesn't exist then create it
if [[ ! -d "$DIR" ]] 
then
    echo "Creating directory project..."
    mkdir "$DIR"
else
    echo "Directory already exists!"
fi

# We access to directory project 
cd "$DIR" || exit

## Task 6 - Run set-demo-api.sh and set-demo-webapp.sh
## We will run two scripts to get both sample applications (demo-api & demo-webapp) 
## clone and configure into local directory project

printf "\n"
echo "Runing main scripts: set-demo-api.sh & set-demo-webapp.sh"
printf "\n"

bash ../set-demo-api.sh && bash ../set-demo-webapp.sh 
