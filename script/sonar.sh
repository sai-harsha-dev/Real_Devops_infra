#!bin/bash

set -xe

# Set sonar installation directory and os platform
USER=sonar
SONARURL="https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-25.3.0.104237.zip"
SONARHOME="/usr/local/bin/sonarhome"
os=$(uname -s)
arch=$(uname -m)
[ "$arch" = "x86_64" ] && arch="x86-64"
platform=${os}-${arch}

# Install and java and sonarqube
if [ ! -d ${SONARHOME} ]
then
    sudo apt install openjdk-17-jre-headless -y
    sudo apt install unzip -y
    sudo curl -o sonarqube ${SONARURL} 
    sudo unzip sonarqube -d ${SONARHOME}
fi 

# Setup Postgress database
#sudo nano /opt/sonarqube/conf/sonar.properties

# Add sonaruser and switch user
! id "${USER}" &>/dev/null && sudo useradd ${USER}
sudo chown -R ${USER}:${USER} ${SONARHOME}
su ${USER}

# Start sonarqube
# ${SONARHOME}/bin/linux*/sonar.sh start --> matches using glob bash operation
${SONARHOME}/bin/${platform}/sonar.sh start