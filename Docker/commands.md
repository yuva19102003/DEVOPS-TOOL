
# Docker Commands and Tips


## Table of Contents

1. [Getting Started](#getting-started)
2. [Docker Basics](#docker-basics)
3. [Managing Containers](#managing-containers)
4. [Managing Images](#managing-images)
5. [Docker Compose](#docker-compose)
6. [Best Practices](#best-practices)

## Getting Started

Before you begin, make sure you have Docker installed on your system. You can download it from the [Docker website](https://www.docker.com/get-started).

To check if Docker is installed and running:

```bash
docker --version
docker info
```

## Docker Basics

### 1. Pull an Image

To pull a Docker image from the Docker Hub:

```bash
docker pull image-name:tag
```

### 2. Run a Container

To run a Docker container:

```bash
docker run -d -p host-port:container-port image-name:tag
```

### 3. List Containers

To list all running containers:

```bash
docker ps
```

### 4. Stop and Remove a Container

To stop and remove a running container:

```bash
docker stop container-id
docker rm container-id
```

## Managing Containers

### 1. Start a Stopped Container

To start a stopped container:

```bash
docker start container-id
```

### 2. View Container Logs

To view the logs of a running container:

```bash
docker logs container-id
```

### 3. Execute a Command in a Running Container

To run a command in a running container:

```bash
docker exec -it container-id command
```

## Managing Images

### 1. List Images

To list all Docker images:

```bash
docker images
```

### 2. Remove an Image

To remove a Docker image:

```bash
docker rmi image-id
```

### 3. Clean Up Unused Images

To remove all unused Docker images:

```bash
docker image prune
```

## Docker Compose

Docker Compose is a tool for defining and running multi-container Docker applications. Create a `docker-compose.yml` file to specify your services and their configurations.

### 1. Start Docker Compose

To start a Docker Compose project:

```bash
docker-compose up -d
```

### 2. Stop Docker Compose

To stop a Docker Compose project:

```bash
docker-compose down
```

### 5. Docker Networking

#### List Docker Networks
To list all Docker networks on your system:

```bash
docker network ls
```

#### Create a Custom Bridge Network
To create a custom bridge network:

```bash
docker network create my-network
```

#### Connect a Container to a Network
To connect a container to a specific network:

```bash
docker network connect my-network container-name
```

#### Inspect a Network
To inspect the details of a Docker network:

```bash
docker network inspect my-network
```

### 6. Docker Volumes

#### Create a Volume
To create a Docker volume:

```bash
docker volume create my-volume
```

#### Mount a Volume in a Container
To mount a volume in a container:

```bash
docker run -d -v my-volume:/path/in/container image-name
```

#### List Volumes
To list all Docker volumes:

```bash
docker volume ls
```

#### Remove a Volume
To remove a Docker volume:

```bash
docker volume rm my-volume
```

### 7. Dockerfile

#### Build an Image from a Dockerfile
To build a Docker image from a Dockerfile in the current directory:

```bash
docker build -t my-image .
```

### 8. Docker Registry

#### Log in to a Docker Registry
To log in to a Docker registry:

```bash
docker login registry-url
```

#### Push an Image to a Registry
To push a Docker image to a registry:

```bash
docker push registry-url/image-name:tag
```

#### Pull an Image from a Registry
To pull a Docker image from a registry:

```bash
docker pull registry-url/image-name:tag
```

### 9. Docker Stats

#### Monitor Container Resource Usage
To monitor resource usage of a running container:

```bash
docker stats container-id
```

### 10. Docker Compose

#### Scale Services
To scale services defined in a `docker-compose.yml` file:

```bash
docker-compose up -d --scale service-name=num-instances
```

mounting the docker socket to inside a docker container

which is for

using docker inside a docker image
```bash
docker run -it -v /var/run/docker.sock:/var/run/docker.sock docker-image:version bin/bash
```
