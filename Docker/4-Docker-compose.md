
# 🐳 Docker Compose Tutorial (Development Focused)

Welcome to the **Docker Compose Tutorial for Development**.  
This guide explains how to use Docker Compose to run **multi-container applications in a development environment**, where:

- Source code changes are reflected in containers
- Containers can be rebuilt easily
- No hot reload tools are required
- Behavior stays close to production

---

## 📑 Table of Contents

1. [Introduction](#introduction)
2. [Prerequisites](#prerequisites)
3. [Installation](#installation)
4. [How Docker Compose Works](#how-docker-compose-works)
5. [Getting Started](#getting-started)
   - [Project Structure](#project-structure)
   - [Creating a docker-compose.yml File](#creating-a-docker-composeyml-file)
   - [Dockerfile for Development](#dockerfile-for-development)
6. [Development Workflow](#development-workflow)
7. [Common Docker Compose Commands](#common-docker-compose-commands)
8. [Examples](#examples)
9. [Tips and Best Practices](#tips-and-best-practices)
10. [Troubleshooting](#troubleshooting)
11. [Resources](#resources)
12. [License](#license)

---

## 📌 Introduction

Docker Compose is a tool that allows you to define and run **multiple Docker containers as a single application**.

Instead of running containers one by one, Docker Compose lets you:
- Define services
- Configure networks
- Attach volumes
- Start everything with one command

This tutorial focuses on **development usage**, not production.

---

## ✅ Prerequisites

Ensure the following are installed:

- Docker
- Docker Compose (included with Docker Desktop)

Verify installation:
```bash
docker --version
docker compose version
````

---

## ⚙ Installation

Follow the official installation guide if Docker is not installed:

* [https://docs.docker.com/get-docker/](https://docs.docker.com/get-docker/)

Docker Compose comes bundled with Docker Desktop (Windows/macOS/Linux).

---

## 🧠 How Docker Compose Works

Conceptually:

```
docker-compose.yml
   ↓
Defines services (app, db, cache, etc.)
   ↓
Docker builds images (if needed)
   ↓
Docker runs containers
   ↓
Containers share network & volumes
```

Key points:

* Each service = one container
* Services can talk using service names
* Volumes persist data
* Bind mounts sync source code

---

## 🚀 Getting Started

### 📁 Project Structure

Example Node.js project:

```
project-root/
├── docker-compose.yml
├── Dockerfile
├── package.json
├── server.js
└── src/
```

---

### 🧩 Creating a `docker-compose.yml` File

This example defines:

* A backend service
* A PostgreSQL database
* Source code mounted for development

```yaml
version: "3.8"

services:
  app:
    build: .
    container_name: dev-app
    ports:
      - "3000:3000"
    volumes:
      - .:/app
    depends_on:
      - db
    environment:
      NODE_ENV: development

  db:
    image: postgres:15
    container_name: dev-db
    environment:
      POSTGRES_DB: devdb
      POSTGRES_USER: devuser
      POSTGRES_PASSWORD: devpass
    volumes:
      - db_data:/var/lib/postgresql/data

volumes:
  db_data:
```

---

### 📄 Dockerfile for Development

This Dockerfile is **simple and explicit**.

```Dockerfile
FROM node:18

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

EXPOSE 3000

CMD ["node", "server.js"]
```

⚠ No hot reload tools (nodemon, pm2) are used.

---

## 🔁 Development Workflow (Important Section)

This setup follows a **manual-rebuild dev workflow**:

### When you change code:

* Source code updates inside container (via volume)
* App **does NOT auto-restart**

### To reflect changes:

```bash
docker compose restart app
```

### If dependencies change:

```bash
docker compose build
docker compose up -d
```

### Full clean rebuild:

```bash
docker compose down
docker compose up -d --build
```

This approach:

* Matches production behavior
* Avoids dev-only tooling
* Keeps environment predictable

---

## 🧪 Common Docker Compose Commands

### Start Services

```bash
docker compose up
docker compose up -d
```

---

### Stop Services

```bash
docker compose down
```

---

### Rebuild Images

```bash
docker compose build
```

---

### Restart a Service

```bash
docker compose restart app
```

---

### View Logs

```bash
docker compose logs
docker compose logs -f app
```

---

### List Containers

```bash
docker compose ps
```

---

### Execute Inside Container

```bash
docker compose exec app bash
```

---

## 📦 Examples

### Node.js + PostgreSQL

* Backend service
* Database service
* Persistent DB volume

### Frontend + Backend

* Frontend container (React/Vue build)
* Backend API container

### Backend + Redis

* Cache layer
* API service dependency

---

## 🧠 Tips and Best Practices

✔ Use bind mounts only in development
✔ Avoid hot reload in Docker unless needed
✔ Keep Dockerfile simple
✔ Use `.dockerignore`
✔ One service = one responsibility
✔ Restart containers explicitly

Example `.dockerignore`:

```
node_modules
.git
.env
```

---

## 🛠 Troubleshooting

### Containers not updating after code change

* Restart the service
* Check volume mounts

### Port already in use

* Change host port
* Stop conflicting service

### Database data lost

* Ensure named volumes are used

---

## 📚 Resources

* Docker Compose Docs: [https://docs.docker.com/compose/](https://docs.docker.com/compose/)
* Docker Docs: [https://docs.docker.com/](https://docs.docker.com/)
* Docker Hub: [https://hub.docker.com/](https://hub.docker.com/)

---

## 📄 License

This project is licensed under the MIT License.

---

## 🎯 Final Notes

This Docker Compose setup is ideal for:

* Backend development
* API services
* Local testing
* CI consistency

It avoids:
❌ Hot reload complexity
❌ Dev-only runtime hacks

---

