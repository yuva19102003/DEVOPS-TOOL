
## 1. Server Requirements

- OS: Ubuntu 20.04 / 22.04
- CPU: 2 cores (4 recommended)
- RAM: 4 GB minimum (8 GB recommended)
- Disk: 10–20 GB
- Docker & Docker Compose installed

---

## 2. Install Docker & Docker Compose

```bash
sudo apt update
sudo apt install -y docker.io docker-compose
sudo systemctl enable docker
sudo systemctl start docker
````

Verify:

```bash
docker --version
docker-compose --version
```

---

## 3. Kernel Tuning (Mandatory)

SonarQube uses Elasticsearch internally.

```bash
sudo sysctl -w vm.max_map_count=262144
sudo sysctl -w fs.file-max=65536
ulimit -n 65536
ulimit -u 4096
```

Persist settings:

```bash
sudo nano /etc/sysctl.conf
```

Add:

```conf
vm.max_map_count=262144
fs.file-max=65536
```

Apply:

```bash
sudo sysctl -p
```

---

## 4. Project Directory Structure

```bash
mkdir -p sonarqube
cd sonarqube

mkdir -p \
  sonarqube-data \
  sonarqube-extensions \
  sonarqube-logs \
  postgres
```

Directory layout:

```text
sonarqube/
├── docker-compose.yml
├── sonarqube-data/
├── sonarqube-extensions/
├── sonarqube-logs/
└── postgres/
```

---

## 5. Docker Compose Configuration

Create `docker-compose.yml`:

```yaml
version: "3.8"

services:
  sonarqube:
    image: sonarqube:latest
    container_name: sonarqube
    depends_on:
      - db
    ports:
      - "9000:9000"
    environment:
      SONAR_JDBC_URL: jdbc:postgresql://db:5432/sonar
      SONAR_JDBC_USERNAME: sonar
      SONAR_JDBC_PASSWORD: sonar
    volumes:
      - ./sonarqube-data:/opt/sonarqube/data
      - ./sonarqube-extensions:/opt/sonarqube/extensions
      - ./sonarqube-logs:/opt/sonarqube/logs
    restart: always

  db:
    image: postgres:17
    container_name: sonar-postgres
    environment:
      POSTGRES_USER: sonar
      POSTGRES_PASSWORD: sonar
      POSTGRES_DB: sonar
    volumes:
      - ./postgres:/var/lib/postgresql/data
    restart: always
```

---

## 6. Fix Permissions (Required)

```bash
sudo chown -R 1000:1000 sonarqube-data sonarqube-extensions sonarqube-logs
sudo chown -R 999:999 postgres
```

Fallback (lab only):

```bash
sudo chmod -R 777 sonarqube-data sonarqube-extensions sonarqube-logs postgres
```

---

## 7. Clean Start (Important)

If you faced **upgrade or authentication errors**, always start clean:

```bash
docker compose down
rm -rf postgres/*
rm -rf sonarqube-data/*
rm -rf sonarqube-extensions/*
rm -rf sonarqube-logs/*
```

---

## 8. Start SonarQube

```bash
docker compose up -d
```

Check logs:

```bash
docker logs sonar-postgres -f
docker logs sonarqube -f
```

Wait until:

```text
SonarQube is up
```

---

## 9. Access SonarQube UI

Open browser:

```text
http://<SERVER_IP>:9000
```

Default login:

```text
Username: admin
Password: admin
```

You will be prompted to **change the password** on first login.

---

## 10. Verify Health

### API check:

```bash
curl http://localhost:9000/api/system/health
```

Expected:

```json
{"health":"GREEN"}
```

---

## 11. Common Issues & Fixes

### SonarQube not starting

```bash
docker logs sonarqube
```

Usually due to:

* Missing kernel tuning
* Old DB data (fix by clean start)

---

### Authentication failed

Reset DB (fresh setup):

```bash
rm -rf postgres/*
rm -rf sonarqube-data/*
```

---

## 12. Best Practices

* Use **PostgreSQL 17** for stability
* Do NOT jump SonarQube major versions without DB reset
* Create a new admin user and disable `admin`
* Use **tokens**, not passwords, in CI/CD
* Back up `postgres/` directory regularly

---

## 13. Next Steps

* Create project & generate token
* Scan Node.js / Go / Java projects
* Integrate with GitHub Actions / GitLab CI
* Configure Quality Gates
* Add Nginx + HTTPS

---
