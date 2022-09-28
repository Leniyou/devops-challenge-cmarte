#!/bin/bash

# set-demo-api.sh

: '

 This script is used to configure Demo API application 
 for the DevOps Challenge - Junior Level at Soluciones GBH
 
 If you read the description in apps-config-script.sh this is
 the Task 6 - Configure .env file and install dependencies

 This script will:
    - Clone Demo API application from github,
    - Install all dependencies using npm install command,
    - Configure environment variables (.env file)
    - Start Demo-API application

'

## - Clone Demo API application from github
echo "Cloning Demo-API app from github repository to local directory project..."
git clone https://github.com/gbh-tech/demo-api
printf "\n"

## We get into demo-api directory that was created by the last "git clone" command
cd demo-api || exit

## - Install dependencies using npm install
echo "Installing local dependencies for Demo-API..."
npm install
printf "\n"

## - Configure environment variables (.env file)
## We can use "mv" or "cp" command. - mv command will replace .env.example file (just for the record)
echo "Configuring Demo-API env variables..."
cp ".env.example" ".env"
printf "\n"

## - Start Demo-API application
echo "Starting Demo-API application..."
pm2 start --name demo-api -p 3001 app.js
printf "\n"
