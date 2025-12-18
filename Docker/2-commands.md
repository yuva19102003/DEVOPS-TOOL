
# 🐳 Docker Commands and Practical Tips

A practical reference for **Docker fundamentals**, **daily-use commands**, and **best practices**.

---

## 📑 Table of Contents

1. [Getting Started](#getting-started)
2. [Docker Basics](#docker-basics)
3. [Managing Containers](#managing-containers)
4. [Managing Images](#managing-images)
5. [Docker Networking](#docker-networking)
6. [Docker Volumes](#docker-volumes)
7. [Dockerfile](#dockerfile)
8. [Docker Compose](#docker-compose)
9. [Docker Registry](#docker-registry)
10. [Monitoring & Debugging](#monitoring--debugging)
11. [Docker-in-Docker & Docker Socket](#docker-in-docker--docker-socket)
12. [Best Practices](#best-practices)

---

## 🚀 Getting Started

Ensure Docker is installed and running:

```bash
docker --version
docker info
````

Check Docker daemon status:

```bash
systemctl status docker
```

Test installation:

```bash
docker run hello-world
```

---

## 🧱 Docker Basics

### Pull an Image

```bash
docker pull image-name:tag
```

Examples:

```bash
docker pull nginx
docker pull node:18
```

---

### Run a Container

```bash
docker run -d -p host-port:container-port image-name:tag
```

Example:

```bash
docker run -d -p 8080:80 nginx
```

---

### List Containers

```bash
docker ps        # running
docker ps -a     # all
```

---

### Stop & Remove Containers

```bash
docker stop container-id
docker rm container-id
```

Force remove:

```bash
docker rm -f container-id
```

---

## 🧩 Managing Containers

### Start / Restart Containers

```bash
docker start container-id
docker restart container-id
```

---

### View Logs

```bash
docker logs container-id
docker logs -f container-id
```

---

### Execute Inside Container

```bash
docker exec -it container-id bash
```

Alternative shells:

```bash
docker exec -it container-id sh
```

---

### Inspect Container

```bash
docker inspect container-id
```

---

### Rename Container

```bash
docker rename old-name new-name
```

---

## 🖼 Managing Images

### List Images

```bash
docker images
```

---

### Remove Images

```bash
docker rmi image-id
docker rmi -f image-id
```

---

### Remove Dangling Images

```bash
docker image prune
```

Remove everything unused:

```bash
docker system prune -a
```

---

### Tag an Image

```bash
docker tag source-image target-image
```

Example:

```bash
docker tag my-app myrepo/my-app:v1
```

---

## 🌐 Docker Networking

### List Networks

```bash
docker network ls
```

---

### Create Network

```bash
docker network create my-network
```

---

### Connect Container to Network

```bash
docker network connect my-network container-name
```

---

### Inspect Network

```bash
docker network inspect my-network
```

---

### Remove Network

```bash
docker network rm my-network
```

---

## 💾 Docker Volumes

### Create Volume

```bash
docker volume create my-volume
```

---

### Mount Volume

```bash
docker run -d -v my-volume:/path/in/container image-name
```

Bind mount example:

```bash
docker run -v $(pwd):/app image-name
```

---

### List Volumes

```bash
docker volume ls
```

---

### Inspect Volume

```bash
docker volume inspect my-volume
```

---

### Remove Volume

```bash
docker volume rm my-volume
```

---

## 📄 Dockerfile

### Build Image

```bash
docker build -t my-image .
```

No cache build:

```bash
docker build --no-cache -t my-image .
```

---

### Example Dockerfile

```Dockerfile
FROM node:18
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3000
CMD ["node", "server.js"]
```

---

## 🧩 Docker Compose

Used for **multi-container applications**.

### Start Services

```bash
docker-compose up -d
```

---

### Stop Services

```bash
docker-compose down
```

---

### View Logs

```bash
docker-compose logs
docker-compose logs -f
```

---

### Scale Services

```bash
docker-compose up -d --scale service-name=3
```

---

### Restart Services

```bash
docker-compose restart
```

---

## 📦 Docker Registry

### Login

```bash
docker login
docker login registry-url
```

---

### Push Image

```bash
docker push registry-url/image-name:tag
```

---

### Pull Image

```bash
docker pull registry-url/image-name:tag
```

---

## 📊 Monitoring & Debugging

### Resource Usage

```bash
docker stats
docker stats container-id
```

---

### Disk Usage

```bash
docker system df
```

---

### Events (Debugging)

```bash
docker events
```

---

## 🐳 Docker-in-Docker & Docker Socket

### 🔥 Mounting Docker Socket (Very Important Concept)

```bash
docker run -it \
  -v /var/run/docker.sock:/var/run/docker.sock \
  docker-image:version \
  bash
```

### ❓ What This Does

* Container can control **host Docker**
* Can create, stop, delete containers
* Used in **CI/CD pipelines**

### ⚠ Security Warning

> Mounting Docker socket = **root access to host**

Use only when necessary.

---

### Docker-in-Docker (DinD)

```bash
docker run --privileged docker:dind
```

Used for:

* CI pipelines
* Testing Docker builds

---

## ✅ Best Practices

✔ Use `.dockerignore`
✔ Use official base images
✔ Keep images small
✔ Don’t run containers as root
✔ Use volumes for data
✔ One process per container
✔ Pin image versions

---

## 🧠 Common Tips

* Use `--rm` for temporary containers

```bash
docker run --rm image-name
```

* Name containers

```bash
docker run --name my-container image-name
```

* Limit resources

```bash
docker run --memory=512m --cpus=1 image-name
```

---

## 🎯 Final Notes

* Docker Image = Blueprint
* Docker Container = Running App
* Dockerfile = Recipe
* Docker Compose = Orchestrator (local)
* Docker Registry = Storage

---

