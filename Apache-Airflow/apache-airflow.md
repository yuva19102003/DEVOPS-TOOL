# 1️⃣ What is Apache Airflow?

**Apache Airflow** is a **workflow orchestration platform**.

Think of it as:

> “A scheduler + executor that runs your jobs in the right order, at the right time, with retries and visibility.”

## 🧠 What You’ll Learn (Roadmap)

1. What Apache Airflow is (mental model)
2. Core Airflow components (with flow)
3. Executors overview (why Celery)
4. Architecture: Airflow + Celery + Redis
5. Local setup (Docker-based, production-like)
6. Writing DAGs (basic → real-world)
7. Task distribution with Celery workers
8. Monitoring, retries, backfills
9. Common commands & debugging
10. Best practices

---

### What Airflow is GOOD at

✅ ETL pipelines
✅ Data engineering workflows
✅ Batch jobs
✅ ML pipelines
✅ Cron replacement with observability

### What Airflow is NOT

❌ Real-time streaming
❌ Event-driven APIs
❌ Long-running services

---

## 2️⃣ Airflow Core Concepts (Very Important)

### 🔹 DAG

* **Directed Acyclic Graph**
* Python file that defines workflow
* Nodes = tasks, edges = dependencies

### 🔹 Task

* A single unit of work
* Example: run a bash command, execute Python, call API

### 🔹 Operator

* Template for a task
* Examples:

  * `PythonOperator`
  * `BashOperator`
  * `DockerOperator`

### 🔹 Scheduler

* Decides **when** tasks should run

### 🔹 Executor

* Decides **how** tasks are executed

---

## 3️⃣ Executors Explained (Why Celery?)

| Executor           | Use Case                  |
| ------------------ | ------------------------- |
| Sequential         | Learning only             |
| LocalExecutor      | Single machine            |
| **CeleryExecutor** | **Distributed, scalable** |
| KubernetesExecutor | Cloud-native              |

### Why CeleryExecutor?

* Multiple workers
* Horizontal scaling
* Reliable for production
* Industry standard

---

## 4️⃣ Architecture: Airflow + Celery + Redis

![Image](https://miro.medium.com/v2/resize%3Afit%3A2000/1%2AavBjYUY6ZtfEyTkk7FI8JQ.png)

![Image](https://airflow.apache.org/docs/apache-airflow-providers-celery/stable/_images/run_task_on_celery_executor.png)

![Image](https://airflow.apache.org/docs/apache-airflow/2.2.4/_images/arch-diag-basic.png)

### Flow (Understand this clearly 👇)

```
DAG → Scheduler → Redis (Queue) → Celery Workers → Result → Metadata DB
```

### Components

| Component      | Role            |
| -------------- | --------------- |
| Webserver      | UI              |
| Scheduler      | Schedules tasks |
| Redis          | Message broker  |
| Celery Workers | Execute tasks   |
| Postgres       | Metadata DB     |

---

## 5️⃣ Install Airflow with Celery + Redis (Docker)

### 📁 Project Structure

```
airflow/
├── dags/
│   └── example_dag.py
├── docker-compose.yml
└── .env
```

---

### 📄 docker-compose.yml

```yaml
version: "3.8"

x-airflow-common: &airflow-common
  image: apache/airflow:2.8.1
  environment:
    AIRFLOW__CORE__EXECUTOR: CeleryExecutor
    AIRFLOW__DATABASE__SQL_ALCHEMY_CONN: postgresql+psycopg2://airflow:airflow@postgres/airflow
    AIRFLOW__CELERY__RESULT_BACKEND: db+postgresql://airflow:airflow@postgres/airflow
    AIRFLOW__CELERY__BROKER_URL: redis://redis:6379/0
    AIRFLOW__CORE__LOAD_EXAMPLES: "false"
  volumes:
    - ./dags:/opt/airflow/dags
  depends_on:
    - redis
    - postgres

services:

  postgres:
    image: postgres:15
    environment:
      POSTGRES_USER: airflow
      POSTGRES_PASSWORD: airflow
      POSTGRES_DB: airflow

  redis:
    image: redis:7

  airflow-webserver:
    <<: *airflow-common
    command: webserver
    ports:
      - "8080:8080"

  airflow-scheduler:
    <<: *airflow-common
    command: scheduler

  airflow-worker:
    <<: *airflow-common
    command: celery worker

  airflow-init:
    <<: *airflow-common
    command: bash -c "airflow db init && airflow users create \
      --username admin \
      --password admin \
      --firstname Admin \
      --lastname User \
      --role Admin \
      --email admin@example.com"
```

---

### ▶️ Start Airflow

```bash
docker compose up -d
```

Access UI:

```
http://localhost:8080
username: admin
password: admin
```

---

## 6️⃣ Your First DAG (Hands-On)

### 📄 dags/example_dag.py

```python
from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime

def hello():
    print("Hello from Airflow Celery Worker!")

with DAG(
    dag_id="hello_celery",
    start_date=datetime(2024, 1, 1),
    schedule_interval="@daily",
    catchup=False,
) as dag:

    task_1 = PythonOperator(
        task_id="hello_task",
        python_callable=hello
    )

    task_1
```

### What happens?

* Scheduler queues task
* Redis stores message
* Celery worker picks it up
* Worker executes task

---

## 7️⃣ Verify Celery Workers Are Working

### Check worker logs

```bash
docker compose logs airflow-worker -f
```

You should see:

```
Task hello_celery.hello_task succeeded
```

🎉 **You are now running distributed Airflow tasks**

---

## 8️⃣ Parallel Tasks Example (Real Practice)

```python
from airflow import DAG
from airflow.operators.bash import BashOperator
from datetime import datetime

with DAG(
    "parallel_tasks",
    start_date=datetime(2024, 1, 1),
    schedule_interval=None,
    catchup=False,
) as dag:

    t1 = BashOperator(
        task_id="task_1",
        bash_command="sleep 10"
    )

    t2 = BashOperator(
        task_id="task_2",
        bash_command="sleep 10"
    )

    t3 = BashOperator(
        task_id="task_3",
        bash_command="sleep 10"
    )

    [t1, t2] >> t3
```

👉 Watch multiple workers executing in parallel.

---

## 9️⃣ Important Airflow CLI Commands

```bash
# List DAGs
airflow dags list

# Trigger DAG
airflow dags trigger hello_celery

# Test task locally
airflow tasks test hello_celery hello_task 2024-01-01

# Check Celery worker
airflow celery status
```

---

## 🔟 Common Problems & Fixes

### ❌ Tasks stuck in "Queued"

✔ Redis not reachable
✔ Worker not running

Check:

```bash
docker compose ps
```

---

### ❌ ImportError in DAG

✔ Missing Python library
✔ Add via custom image or requirements.txt

---

## 🔐 Best Practices (Production Mindset)

✅ One DAG = one business workflow
✅ Use retries & SLA
✅ Avoid heavy logic inside DAG file
✅ Keep tasks idempotent
✅ Version control DAGs
✅ Monitor with Prometheus / StatsD

---

## 🧪 Practice Ideas (Do These Next)

1. ETL pipeline (API → Transform → DB)
2. ML training DAG
3. File processing pipeline
4. Trigger DAG from REST API
5. Add Flower for Celery monitoring
6. Add Airflow variables & connections
7. Use Redis CLI to inspect queues

---

## 🎯 Final Mental Model

```
Airflow = Brain
Scheduler = Planner
Redis = Queue
Celery Workers = Muscle
Postgres = Memory
```

---
