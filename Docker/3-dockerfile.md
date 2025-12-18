
# 🐳 Dockerfile – Full Tutorial (Beginner to Advanced)

This tutorial explains **Dockerfile from scratch**, with **real-world examples** for:

- Golang
- Python
- JavaScript (Node.js, Express.js, React.js)
- Nginx
- Databases (PostgreSQL, MySQL, MongoDB)
- With & without **multi-stage builds**

No assumptions. Everything explained clearly.

---

## 📌 What is a Dockerfile?

A **Dockerfile** is a text file that contains **instructions to build a Docker image**.

Think of it as:
> 📄 **Recipe → Image → Container**

---

## 🧠 Dockerfile Build Flow

```

Dockerfile
↓ docker build
Docker Image
↓ docker run
Docker Container

```

---

## 🧱 Core Dockerfile Instructions (Must Know)

| Instruction | Purpose |
|------------|--------|
| FROM | Base image |
| WORKDIR | Working directory |
| COPY | Copy files |
| RUN | Execute command at build time |
| CMD | Run command at container start |
| ENTRYPOINT | Fixed startup command |
| EXPOSE | Document port |
| ENV | Environment variable |

---

## 1️⃣ Simple Dockerfile (Without Multi-Stage Build)

### Example: Node.js App

#### Project Structure
```

node-app/
├── Dockerfile
├── package.json
└── server.js

````

#### Dockerfile
```Dockerfile
FROM node:18

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

EXPOSE 3000

CMD ["node", "server.js"]
````

### Explanation

* `FROM` → Node + Linux
* `WORKDIR` → Container folder
* `RUN` → Runs during build
* `CMD` → Runs when container starts

---

## 2️⃣ Why Multi-Stage Builds?

Problem without multi-stage:

* Large image
* Build tools included
* Slower deployment

Solution:

> **Build in one stage, run in another**

---

## 3️⃣ Multi-Stage Build (Concept)

```
Stage 1 → Build app
Stage 2 → Copy only output
```

✔ Smaller images
✔ More secure
✔ Production ready

---

## 4️⃣ Golang Dockerfile

### ❌ Without Multi-Stage

```Dockerfile
FROM golang:1.22

WORKDIR /app
COPY . .
RUN go build -o app

CMD ["./app"]
```

⚠ Image contains Go compiler (not ideal)

---

### ✅ With Multi-Stage (Recommended)

```Dockerfile
# Build stage
FROM golang:1.22 AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o app

# Runtime stage
FROM alpine:latest
WORKDIR /app
COPY --from=builder /app/app .
CMD ["./app"]
```

✔ Final image is very small
✔ No Go compiler inside

---

## 5️⃣ Python Dockerfile

### ❌ Without Multi-Stage

```Dockerfile
FROM python:3.11

WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt

COPY . .

CMD ["python", "app.py"]
```

---

### ✅ With Multi-Stage

```Dockerfile
FROM python:3.11 AS builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --user -r requirements.txt

FROM python:3.11-slim
WORKDIR /app
COPY --from=builder /root/.local /root/.local
ENV PATH=/root/.local/bin:$PATH
COPY . .
CMD ["python", "app.py"]
```

---

## 6️⃣ Node.js & Express.js Dockerfile

### ❌ Without Multi-Stage

```Dockerfile
FROM node:18
WORKDIR /app
COPY package*.json .
RUN npm install
COPY . .
CMD ["node", "index.js"]
```

---

### ✅ With Multi-Stage (Production)

```Dockerfile
FROM node:18 AS builder
WORKDIR /app
COPY package*.json .
RUN npm install
COPY . .

FROM node:18-slim
WORKDIR /app
COPY --from=builder /app .
CMD ["node", "index.js"]
```

---

## 7️⃣ React.js Dockerfile

### ❌ Without Multi-Stage (Not Recommended)

```Dockerfile
FROM node:18
WORKDIR /app
COPY . .
RUN npm install && npm run build
CMD ["npm", "start"]
```

---

### ✅ With Multi-Stage (Best Practice)

```Dockerfile
# Build stage
FROM node:18 AS builder
WORKDIR /app
COPY . .
RUN npm install
RUN npm run build

# Serve stage
FROM nginx:alpine
COPY --from=builder /app/build /usr/share/nginx/html
```

✔ React built once
✔ Served via Nginx
✔ Very small image

---

## 8️⃣ Nginx Dockerfile

### Custom Nginx Config

```Dockerfile
FROM nginx:alpine
COPY nginx.conf /etc/nginx/nginx.conf
COPY html/ /usr/share/nginx/html
```

---

## 9️⃣ Database Containers (Best Practice)

⚠ Databases usually **do NOT need custom Dockerfiles**
Use official images.

---

### PostgreSQL

```Dockerfile
FROM postgres:15
```

Run using environment variables:

* POSTGRES_DB
* POSTGRES_USER
* POSTGRES_PASSWORD

---

### MySQL

```Dockerfile
FROM mysql:8
```

---

### MongoDB

```Dockerfile
FROM mongo:7
```

---

## 🔟 Dockerfile Best Practices

✔ Use multi-stage builds
✔ Use slim/alpine images
✔ One process per container
✔ Avoid root user
✔ Use `.dockerignore`
✔ Cache dependencies properly

---

## 📄 Example `.dockerignore`

```
node_modules
.git
.env
dist
build
```

---

## 🔁 CMD vs ENTRYPOINT

### CMD (Overridable)

```Dockerfile
CMD ["node", "app.js"]
```

### ENTRYPOINT (Fixed)

```Dockerfile
ENTRYPOINT ["node"]
CMD ["app.js"]
```

---

## 🧠 Build-Time vs Run-Time

| Phase | Happens When    |
| ----- | --------------- |
| RUN   | Image build     |
| CMD   | Container start |

---

## 🧪 Common Dockerfile Commands

```bash
docker build -t my-app .
docker build --no-cache -t my-app .
docker run my-app
```

---

## 🏁 Final Summary

* Dockerfile defines **how image is built**
* Multi-stage builds = production standard
* Use official images for DBs
* Build heavy → run lightweight

---

## 🚀 What to Learn Next

1. Docker Compose (dev & prod)
2. Docker networking deeply
3. Docker security
4. Kubernetes

---
