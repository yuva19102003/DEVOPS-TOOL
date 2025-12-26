# 🐳 HashiCorp Vault – Docker Compose (Learning Setup)

This setup is:

* ✅ Simple
* ✅ Auto-unsealed
* ✅ Best for learning & testing
* ❌ Not for production

---

## 📁 Directory Structure

```
vault-docker/
└── docker-compose.yml
```

---

## 🧾 `docker-compose.yml`

```yaml
version: "3.8"

services:
  vault:
    image: hashicorp/vault:1.15
    container_name: vault
    ports:
      - "8200:8200"
    environment:
      VAULT_DEV_ROOT_TOKEN_ID: root
      VAULT_DEV_LISTEN_ADDRESS: "0.0.0.0:8200"
    cap_add:
      - IPC_LOCK
    command: vault server -dev
```

---

## ▶️ Start Vault

```bash
docker compose up -d
```

Verify:

```bash
docker ps
```

---

## 🌐 Access Vault

### UI

```
http://localhost:8200
```

### Login Token

```
root
```

---

## 🧪 Test Vault is Running

```bash
docker exec -it vault sh
```

Inside container:

```bash
export VAULT_ADDR=http://127.0.0.1:8200
export VAULT_TOKEN=root

vault status
```

Expected:

```
Sealed: false
Initialized: true
```

---

## ⚠️ Important Notes

* Secrets are **NOT persistent** (lost on restart)
* Vault is **auto-unsealed**
* Root token is **hardcoded** (learning only)

---
