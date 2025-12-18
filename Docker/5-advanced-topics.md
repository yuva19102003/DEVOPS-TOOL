
## 1️⃣ Docker Build Optimization

### Example: Bad vs Good Dockerfile

❌ Bad (breaks cache every build)
```Dockerfile
COPY . .
RUN npm install
````

✅ Good (uses layer caching)

```Dockerfile
COPY package*.json ./
RUN npm install
COPY . .
```

### Commands

```bash
docker build -t app .
docker build --no-cache -t app .
docker history app
```

### Docs

* [https://docs.docker.com/build/cache/](https://docs.docker.com/build/cache/)
* [https://docs.docker.com/develop/develop-images/dockerfile_best-practices/](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)

---

## 2️⃣ CMD vs ENTRYPOINT

### Example

```Dockerfile
ENTRYPOINT ["node"]
CMD ["server.js"]
```

Override CMD:

```bash
docker run app other.js
```

Inspect configuration:

```bash
docker inspect app | grep -A5 Cmd
```

### Docs

* [https://docs.docker.com/engine/reference/builder/#cmd](https://docs.docker.com/engine/reference/builder/#cmd)
* [https://docs.docker.com/engine/reference/builder/#entrypoint](https://docs.docker.com/engine/reference/builder/#entrypoint)

---

## 3️⃣ Environment Variables & Secrets

### Example

```bash
docker run -e DB_HOST=localhost app
docker run --env-file .env app
```

❌ Avoid hardcoding secrets:

```Dockerfile
ENV DB_PASSWORD=secret
```

### Docs

* [https://docs.docker.com/compose/environment-variables/](https://docs.docker.com/compose/environment-variables/)
* [https://docs.docker.com/engine/swarm/secrets/](https://docs.docker.com/engine/swarm/secrets/)

---

## 4️⃣ Multiple Docker Compose Files

### Example

```bash
docker compose -f docker-compose.yml -f docker-compose.dev.yml up
```

### Docs

* [https://docs.docker.com/compose/extends/](https://docs.docker.com/compose/extends/)

---

## 5️⃣ Docker Networking (Deep)

### Example

```bash
docker network create app-net
docker run --network app-net --name api api-image
docker run --network app-net frontend-image
```

Service-to-service access:

```
http://api:3000
```

### Commands

```bash
docker network ls
docker network inspect app-net
```

### Docs

* [https://docs.docker.com/network/](https://docs.docker.com/network/)
* [https://docs.docker.com/network/bridge/](https://docs.docker.com/network/bridge/)

---

## 6️⃣ Volumes vs Bind Mounts

### Volume (Persistent)

```bash
docker volume create dbdata
docker run -v dbdata:/var/lib/postgresql/data postgres
```

### Bind Mount (Development)

```bash
docker run -v $(pwd):/app app
```

### Docs

* [https://docs.docker.com/storage/volumes/](https://docs.docker.com/storage/volumes/)
* [https://docs.docker.com/storage/bind-mounts/](https://docs.docker.com/storage/bind-mounts/)

---

## 7️⃣ Docker Security

### Run as Non-Root

```Dockerfile
RUN adduser --disabled-password appuser
USER appuser
```

### Read-Only Filesystem

```bash
docker run --read-only app
```

### Docs

* [https://docs.docker.com/engine/security/](https://docs.docker.com/engine/security/)
* [https://docs.docker.com/develop/security-best-practices/](https://docs.docker.com/develop/security-best-practices/)

---

## 8️⃣ Resource Management

### Limit Resources

```bash
docker run --memory=512m --cpus=1 app
```

### Monitor Usage

```bash
docker stats
```

### Docs

* [https://docs.docker.com/config/containers/resource_constraints/](https://docs.docker.com/config/containers/resource_constraints/)

---

## 9️⃣ Health Checks

### Dockerfile

```Dockerfile
HEALTHCHECK CMD curl -f http://localhost:3000 || exit 1
```

### Inspect

```bash
docker inspect container | grep Health -A10
```

### Docs

* [https://docs.docker.com/engine/reference/builder/#healthcheck](https://docs.docker.com/engine/reference/builder/#healthcheck)

---

## 🔟 Docker in CI/CD (GitHub Actions Example)

### Example

```yaml
- name: Build Image
  run: docker build -t myapp .

- name: Push Image
  run: docker push myrepo/myapp
```

### Docs

* [https://docs.docker.com/build/ci/](https://docs.docker.com/build/ci/)
* [https://docs.github.com/en/actions](https://docs.github.com/en/actions)

---

## 1️⃣1️⃣ Docker Registry

### Tag & Push

```bash
docker tag app myrepo/app:v1
docker push myrepo/app:v1
```

### Docs

* [https://docs.docker.com/docker-hub/](https://docs.docker.com/docker-hub/)
* [https://docs.aws.amazon.com/AmazonECR/latest/userguide/](https://docs.aws.amazon.com/AmazonECR/latest/userguide/)

---

## 1️⃣2️⃣ Docker-in-Docker vs Docker Socket

### Docker Socket (Preferred)

```bash
docker run -v /var/run/docker.sock:/var/run/docker.sock docker
```

⚠ Gives full control over host Docker.

### Docker-in-Docker

```bash
docker run --privileged docker:dind
```

### Docs

* [https://docs.docker.com/engine/security/#docker-daemon-attack-surface](https://docs.docker.com/engine/security/#docker-daemon-attack-surface)

---

## 1️⃣3️⃣ Logging & Observability

### Logs

```bash
docker logs container
```

### Inspect Logging Driver

```bash
docker inspect container | grep LogConfig -A5
```

### Docs

* [https://docs.docker.com/config/containers/logging/](https://docs.docker.com/config/containers/logging/)

---

## 1️⃣4️⃣ Debugging Containers

### Exec vs Attach

```bash
docker exec -it container bash
docker attach container
```

### Inspect Image Layers

```bash
docker history image
```

### Docs

* [https://docs.docker.com/engine/reference/commandline/inspect/](https://docs.docker.com/engine/reference/commandline/inspect/)

---

## 1️⃣5️⃣ Multi-Architecture Images

### Build Multi-Arch Image

```bash
docker buildx build --platform linux/amd64,linux/arm64 -t app .
```

### Docs

* [https://docs.docker.com/build/buildx/](https://docs.docker.com/build/buildx/)

---

## 1️⃣6️⃣ Docker → Kubernetes Transition

### Why Kubernetes?

* Auto scaling
* Self-healing
* Service discovery

### Docs

* [https://kubernetes.io/docs/concepts/overview/](https://kubernetes.io/docs/concepts/overview/)

---

## 🗺 Recommended Learning Order

```text
Dockerfile
→ Docker Compose
→ Security
→ CI/CD
→ Observability
→ Kubernetes
```

---

## ✅ Final Notes

By practicing the examples in this document, you will:

* Understand Docker deeply
* Be production-ready
* Confidently face DevOps interviews

---

