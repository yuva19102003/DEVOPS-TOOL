# 🎯 Goal of the next phase

You will:

* Understand **Exchange → Queue → Binding**
* Send a message **without writing code**
* Visually see messages flow in RabbitMQ UI

This builds the **mental model** before code.

---

## ✅ STEP 1: Open RabbitMQ UI

👉 [http://127.0.0.1:15672](http://127.0.0.1:15672)
Login:

```
guest / guest
```

---

## ✅ STEP 2: Create an Exchange

1. Go to **Exchanges** tab
2. Click **Add a new exchange**
3. Fill:

| Field       | Value            |
| ----------- | ---------------- |
| Name        | `order_exchange` |
| Type        | `direct`         |
| Durable     | ✅                |
| Auto delete | ❌                |
| Internal    | ❌                |

4. Click **Add exchange**

📌 **Why `direct`?**
Exact routing → easiest to understand first.

---

## ✅ STEP 3: Create a Queue

1. Go to **Queues and Streams**
2. Click **Add a new queue**
3. Fill:

| Field       | Value         |
| ----------- | ------------- |
| Name        | `order_queue` |
| Durable     | ✅             |
| Auto delete | ❌             |
| Exclusive   | ❌             |

4. Click **Add queue**

---

## ✅ STEP 4: Bind Exchange → Queue

1. Open **`order_exchange`**
2. Scroll to **Bindings**
3. Under **Add binding from this exchange**
4. Fill:

| Field       | Value           |
| ----------- | --------------- |
| To queue    | `order_queue`   |
| Routing key | `order.created` |

5. Click **Bind**

📌 This means:

```
routingKey === "order.created" → goes to order_queue
```

---

## ✅ STEP 5: Publish a Test Message (UI)

1. Open **Exchanges → order_exchange**
2. Scroll to **Publish message**
3. Fill:

| Field            | Value                                |
| ---------------- | ------------------------------------ |
| Routing key      | `order.created`                      |
| Payload          | `{ "orderId": 1, "item": "Laptop" }` |
| Payload encoding | `string`                             |

4. Click **Publish message**

---

## ✅ STEP 6: Verify Message in Queue

1. Go to **Queues**
2. Click **order_queue**

You should see:

```
Ready: 1
```

🎉 **Message is safely stored in queue**

---

## ✅ STEP 7: Consume Message from UI (simulate consumer)

1. Inside **order_queue**
2. Scroll to **Get messages**
3. Set:

   * Messages: `1`
   * Ack mode: `Manual ack`
4. Click **Get message(s)**

You’ll see your message body.

---

## 🧠 What you just learned (important)

| Concept     | You did    |
| ----------- | ---------- |
| Exchange    | Created    |
| Queue       | Created    |
| Binding     | Connected  |
| Routing key | Used       |
| Producer    | UI publish |
| Consumer    | UI get     |
| Ack         | Manual     |

This is **exactly how real systems work**, just without code.

---
