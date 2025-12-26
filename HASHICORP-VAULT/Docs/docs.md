# 🔐 HashiCorp Vault – Complete End-to-End Tutorial

---

## 1️⃣ What Problem Vault Solves (Why You Need It)

Without Vault:

* Secrets in `.env` files
* Secrets hardcoded in code
* Secrets stored in GitHub Actions / CI
* Long-lived DB passwords
* Manual rotation ❌

With Vault:

* Central secret store
* Fine-grained access control
* Short-lived (dynamic) credentials
* Automatic rotation
* Auditing

👉 **Vault = single source of truth for secrets**

---

## 2️⃣ Vault Core Concepts (Very Important)

| Concept       | Explanation                         |
| ------------- | ----------------------------------- |
| Secret        | Password, token, API key            |
| Secret Engine | How secrets are stored or generated |
| Auth Method   | How users/apps authenticate         |
| Policy        | What access is allowed              |
| Token         | Temporary access credential         |
| Seal          | Protects master encryption key      |
| Unseal        | Unlocks Vault                       |
| Lease         | Expiry time of a secret             |

---

## 3️⃣ Vault Architecture (How It Works)

![Image](https://developer.hashicorp.com/_next/image?dpl=dpl_2DWWus4CQd1bFR2EQmzi5yQjAG6h\&q=75\&url=https%3A%2F%2Fcontent.hashicorp.com%2Fapi%2Fassets%3Fproduct%3Dtutorials%26version%3Dmain%26asset%3Dpublic%252Fimg%252Fvault%252Fvault-integrated-storage-reference-architecture.svg%26width%3D960.66666667%26height%3D542.41207349\&w=1920\&utm_source=chatgpt.com)

![Image](https://docs.enclaive.cloud/vault/~gitbook/image?dpr=4\&quality=100\&sign=676f8647\&sv=2\&url=https%3A%2F%2F1681203128-files.gitbook.io%2F~%2Ffiles%2Fv0%2Fb%2Fgitbook-x-prod.appspot.com%2Fo%2Fspaces%252FZAOyClhisJhRvjIxLjXP%252Fuploads%252Fogk5OSBe1wnP8FuJ0rnL%252Ffile.excalidraw.svg%3Falt%3Dmedia%26token%3D09d867b8-8f2e-48d1-b389-132f6fba7c22\&width=768\&utm_source=chatgpt.com)

**Flow**

1. Client authenticates
2. Vault checks policy
3. Vault returns secret
4. Secret auto-expires

---

## 4️⃣ Install Vault (Linux – Recommended)

```bash
sudo apt update
sudo apt install -y unzip wget

wget https://releases.hashicorp.com/vault/1.15.5/vault_1.15.5_linux_amd64.zip
unzip vault_1.15.5_linux_amd64.zip
sudo mv vault /usr/local/bin/

vault version
```

---

## 5️⃣ Run Vault (Development Mode – Learning)

```bash
vault server -dev
```

Vault prints:

* Root token
* Address (`127.0.0.1:8200`)

Set env vars:

```bash
export VAULT_ADDR=http://127.0.0.1:8200
export VAULT_TOKEN=root
```

Check:

```bash
vault status
```

---

## 6️⃣ Vault UI

Open:

```
http://127.0.0.1:8200
```

Login with **root token**

---

## 7️⃣ Secrets Engine – KV (Most Used)

### Enable KV v2

```bash
vault secrets enable -path=secret kv-v2
```

### Store Secret

```bash
vault kv put secret/db \
  username=admin \
  password=supersecret
```

### Read Secret

```bash
vault kv get secret/db
```

### Read Single Value

```bash
vault kv get -field=password secret/db
```

---

## 8️⃣ Policies (Access Control)

### Create Policy File

```bash
nano backend-policy.hcl
```

```hcl
path "secret/data/db" {
  capabilities = ["read"]
}
```

### Apply Policy

```bash
vault policy write backend-policy backend-policy.hcl
```

---

## 9️⃣ Authentication Methods

---

### 🔑 A. Userpass (Human Login)

```bash
vault auth enable userpass
```

Create user:

```bash
vault write auth/userpass/users/dev \
  password=dev123 \
  policies=backend-policy
```

Login:

```bash
vault login -method=userpass username=dev
```

---

### 🔑 B. Token Auth (CI/CD)

```bash
vault token create -policy=backend-policy -ttl=1h
```

Used in:

* GitHub Actions
* Jenkins
* GitLab CI

---

### 🔑 C. AppRole (Best for Backend Apps)

✔ Secure
✔ Machine-to-machine
✔ Industry standard

Enable:

```bash
vault auth enable approle
```

Create role:

```bash
vault write auth/approle/role/backend \
  token_policies="backend-policy" \
  token_ttl=1h
```

Get Role ID:

```bash
vault read auth/approle/role/backend/role-id
```

Get Secret ID:

```bash
vault write -f auth/approle/role/backend/secret-id
```

Login using AppRole:

```bash
vault write auth/approle/login \
  role_id=XXXX \
  secret_id=YYYY
```

---

## 🔁 How Backend Uses Vault (Real Flow)

![Image](https://www.datocms-assets.com/2885/1629992136-11-steps-approle.png?utm_source=chatgpt.com)

![Image](https://www.datocms-assets.com/2885/1517516192-vault-approle-workflow2.png?utm_source=chatgpt.com)

---

## 10️⃣ Vault in Node.js Backend (Real Example)

```bash
npm install node-vault
```

```js
import vault from "node-vault";

const client = vault({
  endpoint: "http://127.0.0.1:8200",
  token: process.env.VAULT_TOKEN,
});

const secret = await client.read("secret/data/db");
console.log(secret.data.data.password);
```

---

## 11️⃣ Dynamic Secrets (Power Feature)

Instead of storing DB passwords 👇

### Enable DB Engine

```bash
vault secrets enable database
```

Vault creates:

* Temporary DB users
* Auto-expired credentials

✔ No hardcoded passwords
✔ Auto rotation
✔ Least privilege

---

## 12️⃣ Vault Encryption (Transit Engine)

```bash
vault secrets enable transit
vault write -f transit/keys/app-key
```

Encrypt:

```bash
vault write transit/encrypt/app-key plaintext=$(echo "hello" | base64)
```

Decrypt:

```bash
vault write transit/decrypt/app-key ciphertext=XXXX
```

---

## 13️⃣ Vault Audit Logs (Security)

```bash
vault audit enable file file_path=/var/log/vault_audit.log
```

Tracks:

* Who accessed what
* When
* From where

---

## 14️⃣ Vault Initialization (Production)

```bash
vault operator init
```

Outputs:

* 5 unseal keys
* Root token

### Unseal Vault

```bash
vault operator unseal
```

(Enter **3 different keys**)

---

## 15️⃣ Auto-Unseal (Production MUST)

Use:

* AWS KMS
* Azure Key Vault
* GCP KMS

No manual unseal after restart.

---

## 16️⃣ Vault systemd Service

```bash
sudo nano /etc/systemd/system/vault.service
```

```ini
[Unit]
Description=Vault
After=network.target

[Service]
ExecStart=/usr/local/bin/vault server -config=/etc/vault/config.hcl
Restart=always
User=vault
Group=vault

[Install]
WantedBy=multi-user.target
```

---

## 17️⃣ Vault with Docker

```bash
docker run -d \
  --cap-add=IPC_LOCK \
  -p 8200:8200 \
  hashicorp/vault
```

---

## 18️⃣ Vault with Kubernetes (Industry Standard)

* Kubernetes Auth
* Pod ServiceAccount → Vault
* Secrets injected as env or file

Used by **microservices in prod**

---

## 19️⃣ Best Practices (Real World)

✅ Never use root token
✅ Always use AppRole / K8s auth
✅ Short TTL tokens
✅ Enable audit logs
✅ Use HTTPS
✅ Auto-unseal enabled
✅ One policy per app

---

## 20️⃣ When NOT to Use Vault

❌ Small hobby app
❌ Only 1–2 secrets
❌ No security requirement

---

## 🔥 Real Production Stack Example

```
Frontend → API
Backend → Vault (AppRole)
Vault → DB / API Keys
CI/CD → Vault Token
K8s → Vault Agent
```

---
