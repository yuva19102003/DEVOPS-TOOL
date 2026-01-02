# 🧱 HashiCorp Consul — ALL PILLARS PRACTICAL (Docker)

Tool: **Consul**
Vendor: **HashiCorp**

![Image](https://devopscube.com/content/images/2025/03/image-13-29.png)

![Image](https://developer.hashicorp.com/_next/image?dpl=dpl_GobHkgKRgfw651r6XDhTB3t9RkQm\&q=75\&url=https%3A%2F%2Fcontent.hashicorp.com%2Fapi%2Fassets%3Fproduct%3Dtutorials%26version%3Dmain%26asset%3Dpublic%252Fimg%252Fconsul%252Fregister-services%252Fhealth-checks%252Farch-health-checks-registered-service-instance-light.png%26width%3D1024%26height%3D584%23light-theme-only\&w=2048)

![Image](https://cdn.prod.website-files.com/5d2dd7e1b4a76d8b803ac1aa/5d8b251308d7f835025fc614_Velotio%2B-%2BHashiCorp%2BConsul%2BPost%2B-%2BPart%2B1-23.png)

![Image](https://www.hashicorp.com/_next/image?q=75\&url=https%3A%2F%2Fwww.datocms-assets.com%2F2885%2F1600120093-consulvaultterraform.png\&w=3840)

![Image](https://images.tekanaid.com/BorderedPics-Webblog-App-Part3-Consul-Mesh.png)


---

# 🧠 What We Will Build

```
Consul Server  (control plane)
Consul Client  (worker node)

web service  (nginx)
api service  (http-echo)

✔ Service Discovery
✔ Health Checks
✔ KV Store
✔ ACL Security
✔ Service Mesh (mTLS + intentions)
```

Everything runs in **Docker**.

---

# 0️⃣ Prerequisites

```bash
docker --version
docker compose version
```

---

# 1️⃣ Setup Base Infrastructure (ONCE)

### Create Docker network

```bash
docker network create consul-net
```

---

### Start Consul Server

```bash
docker run -d \
  --name consul-server \
  --network consul-net \
  -p 8500:8500 \
  hashicorp/consul:1.17 \
  agent -dev -client=0.0.0.0
```

👉 UI: [http://localhost:8500](http://localhost:8500)

---

### Start Consul Client

```bash
docker run -d \
  --name consul-client \
  --network consul-net \
  hashicorp/consul:1.17 \
  agent -retry-join=consul-server -client=0.0.0.0
```

Verify:

```bash
docker exec consul-server consul members
```

---

# 🟩 PILLAR 1 — SERVICE DISCOVERY (PRACTICAL)

## What we prove

> Services can be found **by name**, not IP.

---

### Run Web Service

```bash
docker run -d \
  --name web \
  --network consul-net \
  -p 8080:80 \
  nginx
```

---

### Register Web Service

```bash
cat <<EOF > web.json
{
  "service": {
    "name": "web",
    "port": 80
  }
}
EOF
```

```bash
docker cp web.json consul-client:/web.json
docker exec consul-client consul services register /web.json
```

---

### Verify

```bash
docker exec consul-server consul catalog services
```

UI → **Services → web**

✅ **Service discovery pillar complete**

---

# 🟨 PILLAR 2 — HEALTH CHECKS (PRACTICAL)

## What we prove

> Only **healthy services** receive traffic.

---

### Update Service with Health Check

```bash
cat <<EOF > web-health.json
{
  "service": {
    "name": "web",
    "port": 80,
    "check": {
      "http": "http://web",
      "interval": "10s",
      "timeout": "2s"
    }
  }
}
EOF
```

```bash
docker cp web-health.json consul-client:/web-health.json
docker exec consul-client consul services register /web-health.json
```

---

### Break the service

```bash
docker stop web
```

UI:

* web → ❌ **critical**

Restart:

```bash
docker start web
```

UI:

* web → ✅ **passing**

✅ **Health check pillar complete**

---

# 🟦 PILLAR 3 — KEY VALUE STORE (PRACTICAL)

## What we prove

> Centralized, dynamic configuration.

---

### Write config

```bash
docker exec consul-server consul kv put app/env production
docker exec consul-server consul kv put app/feature_x enabled
```

---

### Read config

```bash
docker exec consul-server consul kv get app/env
```

---

### Watch config changes

```bash
docker exec consul-server consul watch \
  -type=key -key=app/env
```

In another terminal:

```bash
docker exec consul-server consul kv put app/env staging
```

👉 Watch triggers instantly

UI → **Key/Value**

✅ **KV pillar complete**

---

# 🟥 PILLAR 4 — ACL & SECURITY (PRACTICAL)

## What we prove

> Zero-trust access control.

---

### Enable ACLs

```bash
docker exec consul-server consul acl bootstrap
```

Copy **SecretID**.

---

### Export token

```bash
export CONSUL_HTTP_TOKEN=PASTE_TOKEN_HERE
```

---

### Create Read-Only Policy

```bash
cat <<EOF > readonly.hcl
node_prefix "" {
  policy = "read"
}
service_prefix "" {
  policy = "read"
}
EOF
```

```bash
docker exec consul-server consul acl policy create \
  -name readonly -rules @readonly.hcl
```

---

### Create Token

```bash
docker exec consul-server consul acl token create \
  -description "readonly-token" \
  -policy-name readonly
```

---

### Test Access

Without token → ❌ denied
With token → ✅ allowed

👉 **This is Consul security in action**

✅ **ACL pillar complete**

---

# 🟪 PILLAR 5 — SERVICE MESH (mTLS + INTENTIONS)

⚠️ This is the **most powerful pillar**

---

## What we prove

✔ mTLS encryption
✔ Service identity
✔ Traffic allow/deny

---

### Register API with Sidecar

```bash
cat <<EOF > api.json
{
  "service": {
    "name": "api",
    "port": 5678,
    "connect": {
      "sidecar_service": {}
    }
  }
}
EOF
```

```bash
docker run -d \
  --name api \
  --network consul-net \
  hashicorp/http-echo -text="hello api"
```

```bash
docker cp api.json consul-client:/api.json
docker exec consul-client consul services register /api.json
```

---

### Default Behavior

❌ web → api = BLOCKED

---

### Create Intention

```bash
docker exec consul-server consul intention create web api
```

Meaning:

```
web → api  ✅ allowed
others     ❌ denied
```

---

### Verify in UI

UI → **Intentions**

👉 This is **zero-trust networking**

✅ **Service mesh pillar complete**

---

# 🧠 FINAL CONSUL PILLARS CHECKLIST

| Pillar            | Status |
| ----------------- | ------ |
| Service Discovery | ✅      |
| Health Checks     | ✅      |
| KV Store          | ✅      |
| ACL Security      | ✅      |
| Service Mesh      | ✅      |

You now ran **EVERY CONSUL FEATURE PRACTICALLY**.

---

# 🏁 What You Are Now Capable Of

You can now:

* Explain Consul end-to-end
* Design service discovery
* Implement zero-trust networking
* Run Consul outside Kubernetes
* Answer **Consul vs Istio / DNS** questions
* Use this in **real DevOps interviews**

---
