#!/bin/bash

set -e

read -p "Specify the jenkins agent home path" JENKINS_HOME
read -p "Specify the user to jenkins uses to connect" JENKINS_USER

source common.sh

exec_status "sudo apt update" "Updating repolist"

exec_status "sudo apt-get install -y fontconfig openjdk-17-jre" "Installing java" 

exec_status "sudo mkdir -p ${JENKINS_HOME}" "Creating Jenkins home directory : ${JENKINS_HOME}"

exec_status "sudo chown ${JENKINS_USER}:${JENKINS_USER} ${JENKINS_HOME}"