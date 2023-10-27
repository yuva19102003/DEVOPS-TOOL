#!/bin/bash

# Check if Java is installed
java_version=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}')
if [ -z "$java_version" ]; then
  # Java is not installed, so let's install it
  echo "Java is not installed. Installing Java..."
  sudo yum install -y java

  # Check if Java installation was successful
  if [ $? -eq 0 ]; then
    echo "Java installed successfully."
    java -version
  else
    echo "Java installation failed. Please check the installation process."
    exit 1
  fi
else
  # Java is already installed, display the version
  echo "Java is already installed. Version: $java_version"
fi

# Install Jenkins
echo "Installing Jenkins..."
sudo yum install -y jenkins

# Start Jenkins service and enable it on boot
sudo systemctl start jenkins
sudo systemctl enable jenkins

# Check Jenkins status
jenkins_status=$(systemctl is-active jenkins)
if [ "$jenkins_status" = "active" ]; then
  echo "Jenkins installed and running."
else
  echo "Jenkins installation or startup failed. Please check the installation process."
fi
