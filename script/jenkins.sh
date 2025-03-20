#!/bin/bash

set -e

source common.sh

echo "Jenkins installation"

exec_status "sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key" "Adding GPG KEY"

exec_status 'echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
 https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list' \
'Adding jenkins repository'

exec_status  "sudo apt-get update -y" "Updating repos"
exec_status  "sudo apt-get install -y fontconfig openjdk-17-jre" "Installing java" 
exec_status  "sudo apt-get install -y jenkins" "Installing Jenkins"

jenkins_pass=$(cat /var/lib/jenkins/secrets/initialAdminPassword)

echo -e "Completed jenkins installation\nADMIN PASSWORD: $jenkins_pass"