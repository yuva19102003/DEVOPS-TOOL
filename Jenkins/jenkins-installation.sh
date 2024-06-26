#!/bin/bash
# this jenkins installation shell script is for installing jenkins in ubuntu ec2 instances
echo "####################################################################################################################################################################################"
echo "******* JENKINS INSTALLATION ********"

echo "####################################################################################################################################################################################"
echo "***** CHECKING JAVA IS INSTALLED OR NOT, THEN INSTALLING JENKINS *****"
echo "####################################################################################################################################################################################"
if command -v java &>/dev/null; then
# checking java is installed or not 
# if installed means then install the jenkins
    echo "Java is installed. Version:"
    java -version
   
    echo "####################################################################################################################################################################################"
    echo "JENKINS INSTALLATION STARTS"
    echo "####################################################################################################################################################################################"
    
    sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
      https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
    echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
      https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
      /etc/apt/sources.list.d/jenkins.list > /dev/null
    sudo apt-get update
    sudo apt-get install jenkins
    
else
# if java is not installed means then install java first
    echo "Java is not installed. Installing Java..."
    
    sudo apt update
    sudo apt install fontconfig openjdk-17-jre
   
    echo "Java is installed. Version:"
    java -version
    # now install the jenkins
    echo "####################################################################################################################################################################################"
    echo "JENKINS INSTALLATION STARTS"
    echo "####################################################################################################################################################################################"
    
    sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
      https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
    echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
      https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
      /etc/apt/sources.list.d/jenkins.list > /dev/null
    sudo apt-get update
    sudo apt-get install jenkins
fi

echo "####################################################################################################################################################################################"
# checking jenkins is running or not by using systemctl command
echo "####################################################################################################################################################################################"
echo "CHECKING JENKINS INSTALLED SUCCESSFULLY OR NOT"
echo "####################################################################################################################################################################################"
sudo systemctl enable jenkins
sudo systemctl start jenkins

echo "####################################################################################################################################################################################"
echo "JENKINS LOGIN PASSWORD "
sudo cat /var/lib/jenkins/secrets/initialAdminPassword > jenkins-password.txt
echo "PASSWORD IS STORED IN 'jenkins-password.txt'.."
echo "####################################################################################################################################################################################"
