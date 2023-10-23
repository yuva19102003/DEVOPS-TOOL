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
    curl -fsSL https://pkg.jenkins.io/debian/jenkins.io-2023.key | sudo tee \
    /usr/share/keyrings/jenkins-keyring.asc > /dev/null
    echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
    https://pkg.jenkins.io/debian binary/ | sudo tee \
    /etc/apt/sources.list.d/jenkins.list > /dev/null
    sudo apt-get update -y
    sudo apt-get install jenkins -y
else
# if java is not installed means then install java first
    echo "Java is not installed. Installing Java..."
    sudo apt-get update
    sudo apt-get install openjdk-11-jre -y
    echo "Java is installed. Version:"
    java -version
    # now install the jenkins
    echo "####################################################################################################################################################################################"
    echo "JENKINS INSTALLATION STARTS"
    echo "####################################################################################################################################################################################"
    curl -fsSL https://pkg.jenkins.io/debian/jenkins.io-2023.key | sudo tee \
    /usr/share/keyrings/jenkins-keyring.asc > /dev/null
    echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
    https://pkg.jenkins.io/debian binary/ | sudo tee \
    /etc/apt/sources.list.d/jenkins.list > /dev/null
    sudo apt-get update -y
    sudo apt-get install jenkins -y
fi
echo "####################################################################################################################################################################################"
# checking jenkins is running or not by using systemctl command
echo "####################################################################################################################################################################################"
echo "CHECKING JENKINS INSTALLED SUCCESSFULLY OR NOT"
echo "####################################################################################################################################################################################"
if systemctl is-active --quiet jenkins; then
    echo "JENKINS INSTALLED AND RUNNING SUCCESSFULLY"
else
    echo "JENKINS NOT INSTALLED AND NOT RUNNING SUCCESSFULLY"
fi
echo "####################################################################################################################################################################################"
echo "JENKINS LOGIN PASSWORD "
cat /var/jenkins_home/secrets/initialAdminPassword > jenkins-password.txt
echo "PASSWORD IS STORED IN 'jenkins-password.txt'.."
echo "####################################################################################################################################################################################"
