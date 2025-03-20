#!/bin/bash

# Installing EFS utils
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh . "$HOME/.cargo/env" 
sudo apt-get update 
sudo apt-get -y install git binutils rustc cargo pkg-config libssl-dev gettext 
git clone https://github.com/aws/efs-utils 
cd efs-utils 
./build-deb.sh 
sudo apt-get -y install ./build/amazon-efs-utils*deb 
sudo apt-get -y install build-essential libwrap0-dev libssl-dev   
sudo curl -o stunnel-5.74.tar.gz https://www.stunnel.org/downloads/stunnel-5.74.tar.gz 
sudo tar xvfz stunnel-5.74.tar.gz 
cd stunnel-5.74/ 
sudo ./configure 
sudo make 
sudo rm /bin/stunnel 
sudo make install 
sudo ln -s /usr/local/bin/stunnel /bin/stunnel 

# Installing AWS CLI
sudo apt install unzip -y
curl -o awscliv2.zip https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip
unzip awscliv2.zip
sudo ./aws/install 

# sudo mount -t efs -o tls fs-02806683304609cb2:/ /var/lib/jenkins 
# sudo mount -t efs -o tls,accesspoint=fsap-05547c65b7c1ae27b fs-02806683304609cb2:/ /var/lib/Jenkins
# sudo mount -t efs -o tls,iam fs-0b897c093f9e50135:/ /var/lib/jenkins

sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
    https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
    https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
    /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update -y 
sudo apt-get install -y fontconfig openjdk-17-jre  
sudo apt-get install -y jenkins

#Change the JENKINS HOME and restart jenkins
sudo systemctl stop jenkins.service
sudo rm -rf /var/lib/jenkins

# Setup filesystem
FILESYSTEM="jenkins-efs"
ACCESSPOINT="jenkins-home"
FILESYSTEM_ID=$(aws efs describe-file-systems --query "FileSystems[?Name=='${FILESYSTEM}'].FileSystemId" --output text)
ACCESSPOINT_ID=$(aws efs describe-access-points --query "AccessPoints[?FileSystemId=='${FILESYSTEM_ID}' && Tags[?Key=='Name' && Value=='${ACCESSPOINT}']].AccessPointId" --output text)
sudo mkdir /var/lib/jenkins
sudo mount -t efs -o tls,accesspoint=${ACCESSPOINT_ID} ${FILESYSTEM_ID}:/ /var/lib/jenkins


# Compare local and efs config and copy config files
# local_size=$(sudo du -s /var/lib/jenkins/ | awk '{print $1}')
# efs_size=$(sudo du -s /var/lib/jenkinsefs/| awk '{print $1}')

# if [ $local_size -gt $efs_size ]
# then
#     sudo rm -rf /var/lib/jenkinsefs/
#     sudo mv /var/lib/jenkins/* /var/lib/jenkinsefs/
# fi

# sudo rm -rf /var/lib/jenkins

# # Update jenkins config and restart the service
# sudo sed -i 's|^JENKINS_HOME=.*|JENKINS_HOME=/var/lib/jenkinsefs|' /etc/default/jenkins
# sudo systemctl daemon-reload
sudo systemctl restart jenkins.service
