#!bin/bash

# Set sonar installation directory and os platform
USER=sonar
SONARURL="https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-25.3.0.104237.zip"
SONARHOME="/usr/local/bin/sonarhome"
os=$(uname -s)
arch=$(uname -m)
[ "$arch" = "x86_64" ] && arch="x86-64"
platform=${os}-${arch}

# Install and java and sonarqube
sudo apt install openjdk-17-jre-headless -y
sudo apt install unzip -y
sudo curl -o sonarqube ${SONARURL} 
sudo unzip sonarqube -d ${SONARHOME} 
sudo chown -R ${USER}:${USER} ${SONARHOME}

# Setup Postgress database
#sudo nano /opt/sonarqube/conf/sonar.properties

# Add sonaruser and switch user
sudo useradd ${USER}
su - ${USER}

# Start sonarqube
# ${SONARHOME}/bin/linux*/sonar.sh start --> matches using glob bash operation
${SONARHOME}/bin/${platform}/sonar.sh start