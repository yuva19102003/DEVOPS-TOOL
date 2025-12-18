
# 🐳 Docker Installation Guide (All Operating Systems)

This guide explains **how to install Docker on every major OS**, with **what happens behind the scenes**, and **simple verification steps**.

You don’t need prior Docker knowledge.

---

## 🧠 Important Concept (Before Installing)

- Docker **runs natively on Linux**
- On **Windows & macOS**, Docker runs inside a **lightweight Linux VM**
- This is handled automatically by **Docker Desktop**

So:
- Linux → Docker Engine directly
- Windows/macOS → Docker Desktop + Linux VM

---

# 🐧 1️⃣ Docker Installation on Linux

Docker works best on Linux.

---

## ✅ Supported Linux Distros
- Ubuntu
- Debian
- CentOS
- RHEL
- Fedora
- Arch

---

## 🔹 Ubuntu / Debian (Most Common)

### Step 1: Update system
```bash
sudo apt update
````

### Step 2: Install Docker

```bash
sudo apt install docker.io -y
```

### Step 3: Start Docker

```bash
sudo systemctl start docker
sudo systemctl enable docker
```

---

## 🔹 Verify Installation

```bash
docker --version
```

---

## 🔹 Run Docker Without `sudo` (Recommended)

```bash
sudo usermod -aG docker $USER
newgrp docker
```

---

## 🔹 Test Docker

```bash
docker run hello-world
```

✔ If you see a success message → Docker is installed correctly

---

## 🔹 CentOS / RHEL / Fedora

### Install Docker

```bash
sudo dnf install docker -y
```

### Start Docker

```bash
sudo systemctl start docker
sudo systemctl enable docker
```

---

# 🪟 2️⃣ Docker Installation on Windows

Windows uses **Docker Desktop**.

---

## ⚠ System Requirements

* Windows 10/11 (64-bit)
* WSL 2 enabled
* Virtualization enabled in BIOS

---

## 🔹 Step 1: Enable WSL 2

Open **PowerShell (Admin)**:

```powershell
wsl --install
```

Restart system.

---

## 🔹 Step 2: Install Docker Desktop

1. Go to **[https://www.docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop)**
2. Download **Docker Desktop for Windows**
3. Install and launch

Docker Desktop will:

* Set up Linux VM
* Configure WSL 2
* Start Docker Engine

---

## 🔹 Verify Installation (PowerShell or CMD)

```powershell
docker --version
```

---

## 🔹 Test Docker

```powershell
docker run hello-world
```

---

## 🧠 What Happens Internally on Windows

```
Windows
 └── WSL2 (Linux Kernel)
      └── Docker Engine
           └── Containers
```

You don’t manage this manually.

---

# 🍎 3️⃣ Docker Installation on macOS

macOS also uses **Docker Desktop**.

---

## ⚠ System Requirements

* macOS 11+
* Intel or Apple Silicon (M1/M2/M3 supported)

---

## 🔹 Step 1: Download Docker Desktop

1. Visit **[https://www.docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop)**
2. Choose:

   * Apple Silicon → M-series
   * Intel → Intel chip
3. Install and open Docker Desktop

---

## 🔹 Verify Installation (Terminal)

```bash
docker --version
```

---

## 🔹 Test Docker

```bash
docker run hello-world
```

---

## 🧠 What Happens Internally on macOS

```
macOS
 └── Linux VM (HyperKit)
      └── Docker Engine
           └── Containers
```

---

# 💻 4️⃣ Docker Installation on Arch Linux

```bash
sudo pacman -S docker
sudo systemctl start docker
sudo systemctl enable docker
```

Add user:

```bash
sudo usermod -aG docker $USER
```

---

# 🧪 5️⃣ Verify Docker Is Working (All OS)

Run:

```bash
docker info
```

You should see:

* Server version
* Storage driver
* Running containers

---

# ❌ Common Installation Issues

### Docker command not found

➡ Docker not installed or PATH issue

### Permission denied

➡ User not added to docker group

### Virtualization disabled

➡ Enable VT-x / AMD-V in BIOS

---

# 🧠 Key Takeaways

| OS      | How Docker Runs           |
| ------- | ------------------------- |
| Linux   | Native (Best performance) |
| Windows | WSL2 Linux VM             |
| macOS   | Lightweight Linux VM      |

---

# ✅ Final Checklist

✔ Docker installed
✔ Docker daemon running
✔ hello-world works
✔ docker without sudo (Linux)

---
