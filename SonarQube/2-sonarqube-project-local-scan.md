
---

# ✅ STEP 1 — Login & Basic Setup

Open in browser:

```
http://<SERVER_IP>:9000
```

Login:

```
Username: admin
Password: admin
```

👉 You’ll be asked to **change password**
Do it and continue.

---

# ✅ STEP 2 — Create Your First Project (Manual)

![Image](https://i.sstatic.net/AEUX5.png?utm_source=chatgpt.com)

![Image](https://www.fosstechnix.com/wp-content/uploads/2023/03/sonarqube_architecture_1.png?utm_source=chatgpt.com)

![Image](https://europe1.discourse-cdn.com/sonarsource/uploads/sonarcommunity/original/1X/ba0d2c8420f6edaee9710037de54e93886c61e23.png?utm_source=chatgpt.com)

1. Click **Create Project**
2. Choose **Manually**
3. Fill:

   * **Project display name:** `my-first-project`
   * **Project key:** `my-first-project`
4. Click **Set Up**

---

# ✅ STEP 3 — Generate Token (VERY IMPORTANT)

![Image](https://codefresh.io/docs/images/testing/sonarqube/generate-token.png?utm_source=chatgpt.com)

![Image](https://europe1.discourse-cdn.com/sonarsource/uploads/sonarcommunity/original/2X/a/a3ff395b15254f4bf7c5a2ed0b4bbeb62f2e574c.png?utm_source=chatgpt.com)

![Image](https://europe1.discourse-cdn.com/sonarsource/uploads/sonarcommunity/optimized/3X/e/5/e5bccc6f92b9d0958ef41a369198c6480d67355f_2_690x298.png?utm_source=chatgpt.com)

1. Choose **Generate Token**
2. Name it: `local-scan`
3. Scope: **Project**
4. Copy the token and **save it securely**

⚠️ You will NOT see this token again.

---

# ✅ STEP 4 — Choose Project Type (Example: Node.js)

Select your tech stack:

* Node.js / JavaScript
* Java
* Go
* Python

I’ll show **Node.js first** (most common).
Tell me if you want another language.

---

# ✅ STEP 5 — Run First Scan (Local)

### 1️⃣ Install Sonar Scanner (Docker way – easiest)

From your project root:

```bash
docker run --rm \
  -e SONAR_HOST_URL="http://<SERVER_IP>:9000" \
  -e SONAR_LOGIN="YOUR_TOKEN" \
  -v "$(pwd):/usr/src" \
  sonarsource/sonar-scanner-cli
```

Replace:

* `<SERVER_IP>`
* `YOUR_TOKEN`

---

### 2️⃣ (Optional) Add `sonar-project.properties`

```properties
sonar.projectKey=my-first-project
sonar.projectName=My First Project
sonar.sources=.
sonar.exclusions=node_modules/**,dist/**
```

Then rerun scanner.

---

# ✅ STEP 6 — View Scan Results

Go back to UI → open your project.

You’ll see:

* Bugs
* Vulnerabilities
* Code smells
* Security hotspots
* Quality Gate status

🎉 **Your first analysis is done**

---

# ✅ STEP 7 — Quality Gate (Understand This)

Default rule:

* ❌ FAIL if new bugs or vulnerabilities
* ❌ FAIL if coverage too low

For now → just observe.

Later we’ll enforce this in CI/CD.

---

