# 🧠 Architecture (what you’re building)

```
┌──────────┐
│  Web UI  │
└────┬─────┘
     │
┌────▼─────┐        ┌───────────┐
│ Scheduler│ ─────▶ │   Redis   │  (broker)
└────┬─────┘        └────┬──────┘
     │                  │
┌────▼─────┐        ┌────▼──────┐
│ Celery   │◀────── │  Worker   │ (n workers)
│ Executor │        └───────────┘
└────┬─────┘
     │
┌────▼─────┐
│ Postgres │ (metadata DB)
└──────────┘
```

---

## 📁 Directory structure

```bash
airflow-celery/
├── dags/
├── logs/
├── plugins/
├── docker-compose.yml
└── .env
```

---

## 📄 `.env` file

```env
AIRFLOW_UID=50000
AIRFLOW_GID=0

POSTGRES_USER=airflow
POSTGRES_PASSWORD=airflow
POSTGRES_DB=airflow
```

---

## 🐳 `docker-compose.yml`

```yaml
version: "3.8"

x-airflow-common: &airflow-common
  image: apache/airflow:2.9.3
  environment:
    &airflow-env
    AIRFLOW__CORE__EXECUTOR: CeleryExecutor
    AIRFLOW__DATABASE__SQL_ALCHEMY_CONN: postgresql+psycopg2://airflow:airflow@postgres/airflow
    AIRFLOW__CELERY__RESULT_BACKEND: db+postgresql://airflow:airflow@postgres/airflow
    AIRFLOW__CELERY__BROKER_URL: redis://redis:6379/0
    AIRFLOW__CORE__FERNET_KEY: ""
    AIRFLOW__CORE__DAGS_ARE_PAUSED_AT_CREATION: "true"
    AIRFLOW__CORE__LOAD_EXAMPLES: "false"
    AIRFLOW__API__AUTH_BACKENDS: airflow.api.auth.backend.basic_auth
  volumes:
    - ./dags:/opt/airflow/dags
    - ./logs:/opt/airflow/logs
    - ./plugins:/opt/airflow/plugins
  user: "${AIRFLOW_UID}:${AIRFLOW_GID}"
  depends_on:
    postgres:
      condition: service_healthy
    redis:
      condition: service_healthy

services:
  postgres:
    image: postgres:15
    environment:
      POSTGRES_USER: airflow
      POSTGRES_PASSWORD: airflow
      POSTGRES_DB: airflow
    volumes:
      - postgres-db-volume:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD", "pg_isready", "-U", "airflow"]
      interval: 10s
      retries: 5
    restart: always

  redis:
    image: redis:7
    ports:
      - "6379:6379"
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 5s
      retries: 5
    restart: always

  airflow-webserver:
    <<: *airflow-common
    command: webserver
    ports:
      - "8080:8080"
    restart: always

  airflow-scheduler:
    <<: *airflow-common
    command: scheduler
    restart: always

  airflow-worker:
    <<: *airflow-common
    command: celery worker
    restart: always

  airflow-init:
    <<: *airflow-common
    command: >
      bash -c "
      airflow db migrate &&
      airflow users create
        --username admin
        --password admin
        --firstname Admin
        --lastname User
        --role Admin
        --email admin@example.com
      "
    restart: "no"

volumes:
  postgres-db-volume:
```

---

## 🚀 How to run (step-by-step)

### 1️⃣ Set permissions (important on Linux)

```bash
mkdir -p dags logs plugins
sudo chown -R 50000:0 .
```

---

### 2️⃣ Initialize Airflow

```bash
docker compose up airflow-init
```

You should see **DB migration + admin user creation**.

---

### 3️⃣ Start all services

```bash
docker compose up -d
```

---

### 4️⃣ Access Airflow UI

```
http://localhost:8080
```

**Login**

```
Username: admin
Password: admin
```

---

## 🧪 Verify Celery + Redis is working

### Check running containers

```bash
docker compose ps
```

You should see:

* airflow-webserver
* airflow-scheduler
* airflow-worker
* redis
* postgres

---

### Check worker logs

```bash
docker compose logs airflow-worker -f
```

You should see:

```
Connected to redis://redis:6379/0
```

---

### Check Redis manually

```bash
docker exec -it airflow-celery-redis-1 redis-cli
PING
```

Expected:

```
PONG
```

---

## 🧩 Sample DAG to test Celery execution

Create `dags/test_celery.py`

```python
from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime

def hello():
    print("Hello from Celery worker!")

with DAG(
    dag_id="celery_test",
    start_date=datetime(2024, 1, 1),
    schedule_interval=None,
    catchup=False,
):
    PythonOperator(
        task_id="hello_task",
        python_callable=hello
    )
```

Trigger the DAG from UI → watch logs → **worker executes task** ✅

---

## ⚙️ Scale Celery workers (real power)

```bash
docker compose up -d --scale airflow-worker=3
```

Now you have **3 parallel workers** processing tasks.

---

## 🔥 Why this setup is production-grade

✔ CeleryExecutor (distributed)
✔ Redis as broker
✔ Postgres as metadata + result backend
✔ Horizontally scalable workers
✔ Clean separation of concerns

---

## 🧭 Next things to learn (recommended)

1. Flower (Celery monitoring)
2. Airflow Pools & Queues
3. Task retries & SLA
4. Remote logging (S3 / GCS)
5. KubernetesExecutor vs CeleryExecutor

---

