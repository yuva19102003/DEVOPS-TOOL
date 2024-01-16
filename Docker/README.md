# INSTALLATION


## Set up Docker on the EC2 instance:

### 1. INSTALLING DOCKER :
    
```bash 
sudo apt-get update
sudo apt-get install docker.io -y
```
### 2. GIVING ROOT USER PERMISSION TO DOCKER DEAMON :
    
```bash
 sudo usermod -aG docker $USER  
 newgrp docker
 sudo chmod 777 /var/run/docker.sock
```
