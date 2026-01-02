# 🧠 HashiCorp Consul — Core Concepts (Foundation First)

> Product by **HashiCorp**
> Tool: **Consul**

Think of this section as **“how Consul thinks”**.
Once this clicks, everything else becomes easy.

![Image](https://developer.hashicorp.com/_next/image?dpl=dpl_GobHkgKRgfw651r6XDhTB3t9RkQm\&q=75\&url=https%3A%2F%2Fcontent.hashicorp.com%2Fapi%2Fassets%3Fproduct%3Dtutorials%26version%3Dmain%26asset%3Dpublic%252Fimg%252Fconsul%252Freference-architecture%252Fconsul-singleDC-redundancyzones.png%26width%3D958%26height%3D720\&w=1920)

![Image](https://devopscube.com/content/images/2025/03/consul-agent-architecture-1.png)

![Image](https://devopscube.com/content/images/2025/03/image-13-29.png)

![Image](https://tekanaid.com/wp-content/uploads/BorderedPics-Webblog-App-Part3-Consul-Mesh.png)

---

## 1️⃣ What Consul *Really* Is (Correct Mental Model)

❌ Consul is **not just service discovery**
❌ Consul is **not just a KV store**
❌ Consul is **not just a service mesh**

✅ **Consul is a Service Networking Control Plane**

> **One-liner:**
> Consul maintains a **real-time, authoritative map of all services, their health, and how they are allowed to talk to each other**.

---

## 2️⃣ The Core Problems Consul Solves

### Problem 1: Dynamic Infrastructure

* IPs change
* Containers restart
* Autoscaling happens

👉 Hardcoding IPs **does not scale**

---

### Problem 2: No Central Health Truth

* Service might be running
* But not *healthy*
* Load balancers don’t always know

👉 You need **health-aware routing**

---

### Problem 3: Insecure Service-to-Service Traffic

* Flat network
* Anyone can talk to anyone
* No identity

👉 Zero Trust is impossible without help

---

### Problem 4: Configuration Sprawl

* Env vars
* Config files
* Secrets everywhere

👉 No single source of truth

---

## 3️⃣ High-Level Building Blocks of Consul

Consul is built from **5 core pillars**:

```
Service Discovery
Health Checking
KV Store
Security (ACL + mTLS)
Service Mesh (Connect)
```

Each pillar builds on the previous one.

---

## 4️⃣ Consul Agent (MOST IMPORTANT CONCEPT)

### What is an Agent?

A **Consul agent** is a process that runs on a machine.

👉 **Every node runs an agent**

The agent is responsible for:

* Registering services
* Running health checks
* Talking to other agents
* Communicating with servers

---

### Two Types of Agents

#### 🟦 Server Agent

* Stores cluster data
* Participates in consensus
* Leader election
* Handles writes

#### 🟩 Client Agent

* Lightweight
* No data storage
* Forwards requests
* Runs health checks

> **Rule:**
> Apps talk to **local agent**, not directly to Consul servers.

---

## 5️⃣ Servers, Quorum & Raft (Why 3 or 5?)

Consul servers use **Raft consensus**.

### Why Raft?

* Strong consistency
* Leader-based writes
* Fault tolerance

### Quorum Rule

> Majority must agree

| Servers | Can tolerate |
| ------- | ------------ |
| 1       | 0 failures ❌ |
| 3       | 1 failure ✅  |
| 5       | 2 failures ✅ |

⚠️ Never use even numbers (2, 4)

---

## 6️⃣ Gossip Protocol (Cluster Awareness)

Consul uses **Gossip** for:

* Node discovery
* Membership tracking
* Failure detection

### Gossip vs Raft

| Gossip                | Raft                |
| --------------------- | ------------------- |
| Fast                  | Consistent          |
| Eventually consistent | Strongly consistent |
| Node health           | Data storage        |

> Gossip tells *who is alive*
> Raft tells *what is true*

---

## 7️⃣ Service Discovery (Core Pillar #1)

### What “Service Discovery” Means

Instead of:

```text
frontend → 10.0.1.12:8080
```

You do:

```text
frontend → backend.service.consul
```

Consul resolves:

* Which instances exist
* Which are healthy
* Returns only valid targets

---

### How It Works (Conceptually)

1. Service starts
2. Registers with local agent
3. Health check attached
4. Added to catalog
5. Consumers query Consul
6. Only healthy services returned

> Discovery is **health-aware by default**

---

## 8️⃣ Health Checks (Core Pillar #2)

Health checks decide **whether a service should receive traffic**.

### Types of Health Checks

| Type   | Example            |
| ------ | ------------------ |
| HTTP   | `/health` endpoint |
| TCP    | DB port check      |
| Script | Custom logic       |
| TTL    | Heartbeat-based    |

---

### Key Insight

> **Running ≠ Healthy**

Consul removes **unhealthy services automatically**.

This enables:

* Self-healing
* Safe autoscaling
* Zero manual intervention

---

## 9️⃣ Consul Catalog (Source of Truth)

The **Catalog** stores:

* Nodes
* Services
* Service instances
* Metadata
* Health status

Think of it as:

> “Live inventory of everything running”

This is what:

* DNS
* API
* UI
  query against.

---

## 🔟 Key-Value Store (Core Pillar #3)

Consul includes a **distributed KV store**.

### What It Is Used For

* Configuration
* Feature flags
* Runtime values
* Shared parameters

### What It Is NOT For

❌ Secrets (use Vault)
❌ Large blobs
❌ High write throughput

---

### Important Concept: Watching

Apps can **watch keys** and react to changes.

> Enables **dynamic reloads without restarts**

---

## 1️⃣1️⃣ ACLs & Security (Core Pillar #4)

Without security:
❌ Anyone can register services
❌ Anyone can read configs
❌ Anyone can change traffic

---

### ACL Concepts

| Term   | Meaning         |
| ------ | --------------- |
| Token  | Identity        |
| Policy | Permissions     |
| Role   | Policy grouping |

> **Everything is denied by default** (Zero Trust)

---

### Why ACLs Matter

* Multi-team environments
* Production safety
* Compliance

---

## 1️⃣2️⃣ Service Mesh (Connect) — Core Pillar #5

### What Is a Service Mesh?

A layer that:

* Encrypts traffic
* Authenticates services
* Controls communication

---

### Consul’s Approach

* Uses **sidecar proxies** (Envoy)
* Apps talk to `localhost`
* Proxies handle mTLS + routing

```
App → Envoy → mTLS → Envoy → App
```

---

### Key Concept: Identity over IP

Services are identified by:

```
service-name + namespace + datacenter
```

Not by IP.

---

## 1️⃣3️⃣ Intentions (Zero-Trust Networking)

Intentions define:

> **Who can talk to whom**

Default behavior:

```
DENY ALL
```

Explicit allow:

```
frontend → backend ✅
frontend → database ❌
```

This is **application-layer firewalling**.

---

## 1️⃣4️⃣ Namespaces & Datacenters

### Datacenter

* Logical isolation
* Independent Raft cluster
* Can be in same or different regions

### Namespace

* Multi-tenant separation
* Teams / environments

Example:

```
dc=prod
namespace=payments
service=api
```

---

## 1️⃣5️⃣ Multi-Datacenter Federation

Consul can connect:

* AWS ↔ Azure
* On-prem ↔ cloud
* Region ↔ region

Each DC:

* Independent failure domain
* Shared service discovery

---

## 1️⃣6️⃣ UI & APIs (Control Plane Access)

Consul exposes:

* HTTP API
* DNS interface
* Web UI

Everything you do:

* CLI
* UI
* Automation

→ Hits the same APIs.

---

## 1️⃣7️⃣ Where Consul Fits (Big Picture)

Consul often sits **between**:

```
Applications
↓
Consul (service networking)
↓
Infrastructure (VMs / K8s / Cloud)
```

It is **not** a scheduler
It is **not** a container runtime

It complements:

* Kubernetes
* Nomad
* Terraform
* Vault

---

## ✅ Final Concept Summary (Lock This In)

> **Consul maintains a consistent, secure, health-aware map of services and controls how they communicate — across machines, clusters, and datacenters.**

If this mental model is clear, you’re 70% done.

---

