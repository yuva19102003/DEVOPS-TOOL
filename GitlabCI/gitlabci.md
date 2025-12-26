# 🚀 Full End-to-End GitLab CI/CD Tutorial

> Works for **Node.js / Go / Python / any app**
> Assumes you’re using **GitLab**

---

## 1️⃣ What is GitLab CI/CD (Big Picture)

**GitLab CI/CD** is:

* Built-in CI/CD system inside GitLab
* Runs jobs using **GitLab Runners**
* Controlled by **one file** → `.gitlab-ci.yml`

### CI/CD Flow

```
Code Push → Pipeline → Jobs → Artifacts → Deploy
```

---

## 2️⃣ Core Components (Must Know)

### 🔹 1. `.gitlab-ci.yml`

* Pipeline definition file
* Must be at repo root

### 🔹 2. Pipeline

* Created on every push / merge / trigger

### 🔹 3. Stages

* Execution order (`build → test → deploy`)

### 🔹 4. Jobs

* Actual tasks that run commands

### 🔹 5. GitLab Runner

* Machine that executes jobs
* Can be:

  * Shared runner (GitLab provided)
  * Self-hosted runner (VM / Docker / Kubernetes)

---

## 3️⃣ Your First Pipeline (Hello World)

### 📄 `.gitlab-ci.yml`

```yaml
stages:
  - test

hello_job:
  stage: test
  script:
    - echo "GitLab CI is working!"
```

### ✅ What happens

1. Push code
2. GitLab detects `.gitlab-ci.yml`
3. Pipeline starts
4. Job runs on runner
5. Output appears in job logs

---

## 4️⃣ Multi-Stage Pipeline (Real Structure)

```yaml
stages:
  - build
  - test
  - deploy

build:
  stage: build
  script:
    - echo "Building app"

test:
  stage: test
  script:
    - echo "Running tests"

deploy:
  stage: deploy
  script:
    - echo "Deploying app"
```

### 📌 Rules

* Stages run **sequentially**
* Jobs inside same stage run **in parallel**

---

## 5️⃣ Using Docker Images (Very Important)

GitLab jobs run **inside Docker containers**.

### Example: Node.js

```yaml
image: node:20

stages:
  - install
  - test

install:
  stage: install
  script:
    - npm install

test:
  stage: test
  script:
    - npm test
```

### Example: Go

```yaml
image: golang:1.22

build:
  script:
    - go build ./...
```

---

## 6️⃣ Variables & Secrets (Critical Topic)

### 🔹 CI Variables (UI)

GitLab → **Settings → CI/CD → Variables**

Example:

```
DB_PASSWORD=supersecret
```

### 🔹 Use in pipeline

```yaml
script:
  - echo "$DB_PASSWORD"
```

✔ Masked
✔ Encrypted
✔ Safe for secrets

---

## 7️⃣ Branch-Based Pipelines

### Run job only on `main`

```yaml
deploy:
  script:
    - echo "Deploying..."
  only:
    - main
```

### Run job except `main`

```yaml
test:
  script:
    - echo "Test"
  except:
    - main
```

---

## 8️⃣ Artifacts (Passing Files Between Jobs)

### Example: build → deploy

```yaml
build:
  stage: build
  script:
    - mkdir dist
    - echo "hello" > dist/app.txt
  artifacts:
    paths:
      - dist/

deploy:
  stage: deploy
  script:
    - cat dist/app.txt
```

Artifacts:

* Stored temporarily
* Downloadable from GitLab UI

---

## 9️⃣ Cache (Speed Up Pipelines)

### Node.js cache

```yaml
cache:
  paths:
    - node_modules/

install:
  script:
    - npm install
```

✔ Faster pipelines
✔ Less downloads

---

## 🔟 Docker Build & Push (Very Important for DevOps)

### Requirements

* Dockerfile
* GitLab Container Registry enabled

### Pipeline

```yaml
image: docker:24
services:
  - docker:24-dind

variables:
  DOCKER_TLS_CERTDIR: ""

stages:
  - build

docker_build:
  stage: build
  script:
    - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
    - docker build -t $CI_REGISTRY_IMAGE:latest .
    - docker push $CI_REGISTRY_IMAGE:latest
```

GitLab auto-provides:

* `CI_REGISTRY`
* `CI_REGISTRY_USER`
* `CI_REGISTRY_PASSWORD`

---

## 1️⃣1️⃣ Environments (Dev / Staging / Prod)

```yaml
deploy_dev:
  stage: deploy
  script:
    - echo "Deploying to DEV"
  environment:
    name: dev
```

You can track deployments in **GitLab → Environments**

---

## 1️⃣2️⃣ Manual Jobs (Safe Deploy)

```yaml
deploy_prod:
  stage: deploy
  script:
    - echo "Deploying PROD"
  when: manual
```

✔ Prevents accidental prod deploys
✔ Interview favorite

---

## 1️⃣3️⃣ Self-Hosted Runner (Real World)

### Install runner

```bash
curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | sudo bash
sudo apt install gitlab-runner
```

### Register runner

```bash
gitlab-runner register
```

Choose:

* Executor → `docker`
* Default image → `ubuntu:22.04`

---

## 1️⃣4️⃣ Common GitLab CI Errors (Must Know)

| Error                    | Meaning                       |
| ------------------------ | ----------------------------- |
| No runner available      | No runner assigned            |
| Job stuck                | Runner offline                |
| Permission denied        | Missing executable permission |
| Docker command not found | Missing docker:dind           |

---

## 1️⃣5️⃣ Production-Ready Sample (Node.js)

```yaml
image: node:20

stages:
  - install
  - test
  - build

cache:
  paths:
    - node_modules/

install:
  stage: install
  script:
    - npm install

test:
  stage: test
  script:
    - npm test

build:
  stage: build
  script:
    - npm run build
  artifacts:
    paths:
      - dist/
```

---

## 1️⃣6️⃣ CI/CD Best Practices (Interview Gold)

✔ Use **stages**
✔ Use **cache**
✔ Protect **secrets**
✔ Manual prod deploy
✔ Separate environments
✔ Fail fast (tests early)

---

## 🎯 What You Should Practice Next

I recommend this order:

1. ✅ Simple pipeline
2. ✅ Docker build
3. ✅ Branch-based deploy
4. ✅ Environment deploy
5. ✅ Self-hosted runner

---
