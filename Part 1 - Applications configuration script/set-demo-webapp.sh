#!/bin/bash

# set-demo-webapp.sh

: '

 This script is used to configure Demo Webapp Client application 
 for the DevOps Challenge - Junior Level at Soluciones GBH
 
 If you read the description in apps-config-script.sh this is
 the Task 6 - Configure .env file and install dependencies

 This script will:
    - Clone Demo Webapp Client application from github,
    - Install all dependencies using npm install command,
    - Configure environment variables,
    - Build the demo app
    - Start Demo-webapp

'

## - Clone Demo Webapp Client application
echo "Cloning Demo-Webapp app from github repository to local directory project..."
git clone https://github.com/gbh-tech/demo-webapp
printf "\n"

## We get into demo-webapp directory that was created by the last "git clone" command
cd demo-webapp || exit

## - Install all dependencies
echo "Installing local dependencies for Demo-Webapp..."
npm install
printf "\n"

## - Configure environment variables (.env file)
## We can use "mv" or "cp" command. mv command will replace .env.example file (just for the record)
echo "Configuring Demo-Webapp env variables..."
cp ".env.example" ".env"
printf "\n"

## Building the app
echo "Building app..."
npm run build
printf "\n"

## - Start Demo-Webapp application
echo "Starting Demo-webapp application..."
pm2 start --name demo-webapp -p 3000 ./src/App.js
printf "\n"
