#!/bin/bash

# installing docker in the machine (bootstrap)
sudo apt-get update -y

# installing docker
sudo apt-get install docker.io -y

# giving permission
sudo usermod -aG docker $USER  
newgrp docker
sudo chmod 777 /var/run/docker.sock

# pull the images
docker pull yuva19102003/apache:latest

# run the container
docker run -d -p 8080:80 --name my_apache_container yuva19102003/apache:latest