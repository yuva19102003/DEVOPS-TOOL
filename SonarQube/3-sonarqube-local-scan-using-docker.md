# Testing SonarQube Scanner Using Docker (Local)

This guide shows how to **test a SonarQube token locally** using the  
**Sonar Scanner Docker image**, without installing Java or the scanner on your host.

> ✅ Linux-friendly  
> ✅ Uses Docker only  
> ✅ Works with SonarQube running locally  
> ✅ Production-style workflow

---

## 1. Prerequisites

Make sure the following are ready:

- SonarQube server is **running**
- You have a **project created** in SonarQube
- You have a **SonarQube token**
- Docker is installed
- You are inside your project directory

Verify SonarQube status:
```bash
curl http://localhost:9000/api/system/status
````

Expected:

```json
{"status":"UP"}
```

---

## 2. Project Structure (Example)

```text
freelance-portfolio/
├── sonar-project.properties
├── package.json
├── src/
└── node_modules/
```

---

## 3. Create `sonar-project.properties`

Create the file in the project root:

```bash
nano sonar-project.properties
```

Add:

```properties
sonar.projectKey=freelance-portfolio
sonar.projectName=Freelance Portfolio
sonar.projectVersion=1.0

sonar.sources=.
sonar.sourceEncoding=UTF-8

sonar.exclusions=node_modules/**,dist/**,build/**
```

⚠️ `sonar.projectKey` must **exactly match** the project key in SonarQube UI.

---

## 4. Run Sonar Scanner Using Docker (Linux – Recommended)

On Linux, use **host networking** so the container can reach SonarQube.

```bash
docker run --rm \
  --network=host \
  -e SONAR_HOST_URL="http://localhost:9000" \
  -e SONAR_TOKEN="YOUR_SONAR_TOKEN" \
  -v "$(pwd):/usr/src" \
  sonarsource/sonar-scanner-cli
```

Replace `YOUR_SONAR_TOKEN` with your actual token.

---

## 5. Expected Success Output

If everything is correct, you will see:

```text
ANALYSIS SUCCESSFUL
You can browse http://localhost:9000/dashboard?id=freelance-portfolio
```

This confirms:

* Token is valid
* Scanner can reach SonarQube
* Project analysis completed

---

## 6. Verify Results in SonarQube UI

Open:

```text
http://localhost:9000
```

Navigate to:

```
Projects → Freelance Portfolio
```

You should see:

* Bugs
* Vulnerabilities
* Code Smells
* Coverage (if available)

---

## 7. Debug Mode (Optional)

If the scan fails, run in debug mode:

```bash
docker run --rm \
  --network=host \
  -e SONAR_HOST_URL="http://localhost:9000" \
  -e SONAR_TOKEN="YOUR_SONAR_TOKEN" \
  -v "$(pwd):/usr/src" \
  sonarsource/sonar-scanner-cli -X
```

This prints detailed logs for troubleshooting.

---

## 8. Common Errors & Fixes

### ❌ Failed to query server version

Cause:

* Docker container cannot reach SonarQube

Fix:

* Use `--network=host` on Linux

---

### ❌ Not authorized

Cause:

* Invalid or deleted token

Fix:

* Regenerate token and retry

---

### ❌ Project not found

Cause:

* Project key mismatch

Fix:

* Ensure `sonar.projectKey` matches UI

---

## 9. Token Validation (Optional)

Validate token manually:

```bash
curl -u YOUR_SONAR_TOKEN: http://localhost:9000/api/authentication/validate
```

Expected:

```json
{"valid":true}
```

---

## 10. Best Practices

* Do NOT commit tokens to Git
* Use environment variables in CI/CD
* Use tokens instead of passwords
* Exclude `node_modules`, build artifacts
* Run scans only after build/test steps

---

## 11. Next Steps

* Add **Quality Gates**
* Integrate with **GitHub Actions / GitLab CI**
* Add **test coverage**
* Secure SonarQube with **HTTPS**

---

✅ **Local Sonar Scanner testing using Docker is complete**
