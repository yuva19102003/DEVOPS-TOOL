# 🔰 SECTION 0 — Redis Fundamentals (Before Any Commands)

![Image](https://substackcdn.com/image/fetch/%24s_%21OsiQ%21%2Cf_auto%2Cq_auto%3Agood%2Cfl_progressive%3Asteep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F778a7e21-455b-45f6-8487-63f9eb41e88b_2000x1414.jpeg)

![Image](https://scaleyourapp.com/wp-content/uploads/2020/07/single-threaded-event-loop-architecture.png)

### 🧠 What Redis really is (important)

Redis is:

* A **single-threaded** event loop
* Holding data **entirely in RAM**
* Persisting to disk **optionally**
* Optimized for **very fast reads/writes**

> Redis is fast **because it avoids locks and disk I/O**

---

### 🧩 Internal mental model

```
KEY (string)
  ↓
Value (string | hash | list | set | zset | stream)
  ↓
Stored in RAM
  ↓
Optional persistence to disk
```

---

## 🔌 Start & Connect (once)

```bash
docker run -d --name redis-lab -p 6379:6379 redis:7
redis-cli
```

Test:

```bash
PING
```

Redis replies:

```
PONG
```

Meaning:

> Redis event loop is alive and accepting commands

---

# 1️⃣ STRING — The Atomic Unit of Redis

---

## 🧠 Why strings exist

Strings are:

* The **fastest** Redis type
* Atomic (safe for counters)
* Used in **90% of Redis use cases**

### Real-world uses

* Cache values
* Session tokens
* Feature flags
* Counters
* Locks

---

## 🧩 How Redis stores a string

Internally:

* Key is always a string
* Value is a byte array
* TTL stored separately

```
"session:123" → "active" (TTL: 60s)
```

---

## 🧪 Step-by-step

### Step 1 — Store value

```bash
SET user:name "yuva"
```

Redis does:

* Allocates memory
* Stores key hash
* Stores value bytes

---

### Step 2 — Read value

```bash
GET user:name
```

Redis:

* Hashes key
* Direct memory lookup
* Returns value

---

### Step 3 — Add TTL (CRITICAL)

```bash
SET session:1 "active" EX 30
TTL session:1
```

🔍 What happens internally:

* Redis adds expiry metadata
* Key auto-deletes after TTL

Why TTL matters:

> Redis **will crash** if you forget TTLs in cache-heavy systems

---

### Step 4 — Atomic counter

```bash
SET api:count 0
INCR api:count
INCR api:count
```

Why `INCR` is special:

* No race condition
* Single-threaded atomic op

Used for:

* Rate limiting
* Analytics
* Quotas

---

🚫 **DON’T**

* Store large JSON blobs
* Use strings without TTL for cache

---

# 2️⃣ HASH — Structured Data Without JSON

---

## 🧠 Why hashes exist

Hashes solve:

* Storing structured data
* Updating single fields
* Avoiding JSON parsing

### Real-world uses

* User profiles
* Product metadata
* Configuration

---

## 🧩 Internal model

```
user:1
 ├─ name → "yuva"
 ├─ role → "devops"
 └─ age  → "21"
```

Redis stores fields compactly → memory efficient.

---

## 🧪 Step-by-step

### Step 1 — Create hash

```bash
HSET user:1 name "yuva" role "devops" age 21
```

Redis:

* Creates hash table
* Stores fields separately

---

### Step 2 — Read data

```bash
HGET user:1 name
HGETALL user:1
```

Why hashes are fast:

* Field lookup is O(1)

---

### Step 3 — Update one field

```bash
HSET user:1 role "cloud"
```

Only `role` changes — no full rewrite.

---

### Step 4 — Expiry on hash

```bash
EXPIRE user:1 60
```

⚠ TTL applies to **entire hash**, not fields.

---

🚫 **DON’T**

* Store nested JSON in hashes
* Use hashes without TTL in cache

---

# 3️⃣ LIST — Ordered Queue / Stack

---

## 🧠 Why lists exist

Lists solve:

* Queues
* Background jobs
* Message buffering

### Real-world uses

* Job queues
* Email sending
* Event buffering

---

## 🧩 Internal model

```
jobs → [job3, job2, job1]
```

Linked list internally → fast push/pop.

---

## 🧪 Step-by-step

### Step 1 — Push jobs

```bash
LPUSH jobs job1
LPUSH jobs job2
RPUSH jobs job3
```

---

### Step 2 — View list

```bash
LRANGE jobs 0 -1
```

---

### Step 3 — Pop job (worker)

```bash
RPOP jobs
```

FIFO achieved by:

```
LPUSH → RPOP
```

---

### Step 4 — Blocking pop (IMPORTANT)

```bash
BLPOP jobs 10
```

Meaning:

* Worker waits
* No CPU waste
* Production-safe

---

🚫 **DON’T**

* Use lists for durable queues
* Use lists without monitoring length

---

# 4️⃣ SET — Fast Membership & Uniqueness

---

## 🧠 Why sets exist

Sets solve:

* Uniqueness
* Membership checks
* Grouping

### Real-world uses

* Online users
* Feature flags
* Permissions

---

## 🧩 Internal model

Unordered hash set:

```
online_users → {u1, u2, u3}
```

---

## 🧪 Step-by-step

```bash
SADD online_users user1 user2
SISMEMBER online_users user1
SMEMBERS online_users
```

Membership check is **O(1)** — extremely fast.

---

### Set math (powerful)

```bash
SINTER teamA teamB
SUNION teamA teamB
SDIFF teamA teamB
```

Used for:

* Access control
* A/B testing

---

🚫 **DON’T**

* Expect ordering
* Store huge sets without memory limits

---

# 5️⃣ SORTED SET — Ranking & Time-Based Logic

---

## 🧠 Why sorted sets exist

Sorted sets solve:

* Ranking
* Priority
* Time ordering

### Real-world uses

* Leaderboards
* Rate limiting
* Scheduling

---

## 🧩 Internal model

```
member → score
```

Score determines order.

---

## 🧪 Step-by-step

```bash
ZADD leaderboard 100 user1
ZADD leaderboard 200 user2
ZRANGE leaderboard 0 -1 WITHSCORES
```

---

### Update score

```bash
ZINCRBY leaderboard 10 user1
```

Used for:

* Sliding window rate limits
* Priority queues

---

🚫 **DON’T**

* Use lists for ranking
* Forget score precision

---

# 6️⃣ TTL & Expiry — Redis Safety Valve

---

## 🧠 Why expiry is critical

Redis memory is finite.
TTL prevents:

* OOM crashes
* Memory leaks

---

## 🧪 Commands

```bash
TTL key
EXPIRE key 60
PERSIST key
```

Redis deletes keys:

* Lazily on access
* Actively via background cleanup

---

# 7️⃣ Pub/Sub — Fire-and-Forget Messaging

---

## 🧠 Why Pub/Sub exists

* Real-time fan-out
* Low latency
* No persistence

---

## 🧪 Demo

Terminal 1:

```bash
SUBSCRIBE alerts
```

Terminal 2:

```bash
PUBLISH alerts "server down"
```

⚠ Message lost if no subscriber.

---

# 8️⃣ Streams — Durable Messaging (Advanced)

---

## 🧠 Why streams exist

Streams solve:

* Reliable messaging
* Event sourcing
* Replayability

---

## 🧪 Demo

```bash
XADD orders * userId 1 amount 500
XRANGE orders - +
```

Consumer group:

```bash
XGROUP CREATE orders cg1 $
XREADGROUP GROUP cg1 worker1 STREAMS orders >
```

Used instead of:

* Pub/Sub
* Lists (for jobs)

---

# 9️⃣ Persistence — Data Survival

---

## 🧠 Redis is RAM-first

Persistence is **backup**, not primary storage.

---

## 🧪 Check config

```bash
CONFIG GET save
CONFIG GET appendonly
```

Enable AOF:

```bash
CONFIG SET appendonly yes
```

---

# 🔐 10️⃣ Security Basics

```bash
CONFIG SET requirepass StrongPass
AUTH StrongPass
```

Never expose Redis publicly.

---

# 🏁 FINAL TRUTH ABOUT REDIS

> Redis is **not a database replacement**
> Redis is a **performance accelerator**

---
