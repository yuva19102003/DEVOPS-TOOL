# ✅ Docker Compose (management enabled automatically)

### `docker-compose.yml`

```yaml
services:
  rabbitmq:
    image: rabbitmq:latest
    container_name: rabbitmq
    ports:
      - "5672:5672"     # AMQP
      - "15672:15672"   # Management UI
    command: >
      sh -c "
        rabbitmq-plugins enable --offline rabbitmq_management &&
        rabbitmq-server
      "
```

### Why this works

* `--offline` → enables plugin **before broker starts**
* `rabbitmq-server` → starts RabbitMQ normally
* No manual `docker exec` needed
* Works reliably with **RabbitMQ 4.x**

---

## ▶️ Run fresh (important)

Do a **clean start**:

```bash
docker compose down
docker rm -f rabbitmq
docker compose up -d
```

Wait ~10 seconds.

---

## 🌐 Open Management UI

👉 **Use this (Linux-safe):**

```
http://127.0.0.1:15672
```

Login:

```
username: guest
password: guest
```

---

## 🔍 Verify plugin (optional)

```bash
docker exec -it rabbitmq rabbitmq-plugins list | grep management
```

You should see:

```
[E*] rabbitmq_management
```

---

## 🧠 Important learning (real-world insight)

### Why NOT `rabbitmq:3-management`?

* That image is **legacy convenience**
* Real production setups:

  * Use `rabbitmq:latest`
  * Explicitly enable plugins
  * Controlled startup

You’re now following **real DevOps / SRE practice**, not tutorial shortcuts 💪

---

