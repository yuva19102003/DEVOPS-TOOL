# 🚀 Packer — Full End-to-End Tutorial

*(Beginner → Startup → Enterprise)*

![Image](https://developer.hashicorp.com/_next/image?dpl=dpl_24nEjyEDEdjkhNFm7NzoFKoLw6bU\&q=75\&url=https%3A%2F%2Fcontent.hashicorp.com%2Fapi%2Fassets%3Fproduct%3Dtutorials%26version%3Dmain%26asset%3Dpublic%252Fimg%252Fpacker%252Fhcp-golden-image-pipeline%252Fgolden_image_pipeline_flow.png%26width%3D960%26height%3D720\&w=1920)

![Image](https://www.nielskok.tech/wp-content/uploads/2021/12/PackerArchitecture-1.png)

![Image](https://miro.medium.com/1%2A4QGMdjuyllK9qqsrqy_2EA.jpeg)

---

## 🧠 What Packer Actually Does

**HashiCorp Packer** builds **machine images automatically**.

Instead of:

* Manually creating VMs
* Installing software again and again
* Debugging “works on my server”

You:

* Define image once
* Build it consistently
* Reuse it everywhere

---

## 🧱 Where Packer Fits (Mental Model)

```
Packer  →  Golden Image  →  Terraform  →  Servers
Bake        Approve          Serve
```

> **Packer bakes the server**
> **Terraform serves the server**

---

# 1️⃣ Install Packer

### Linux

```bash
sudo apt update
sudo apt install packer -y
```

### macOS

```bash
brew install packer
```

### Verify

```bash
packer version
```

---

# 2️⃣ Core Packer Concepts (Non-Negotiable)

| Term        | Meaning                                   |
| ----------- | ----------------------------------------- |
| Builder     | Where image is built (AWS, Azure, Docker) |
| Provisioner | What is installed                         |
| Source      | Image definition                          |
| Build       | Execution logic                           |
| Template    | `.pkr.hcl` file                           |

---

# 3️⃣ Golden Image Strategy (Enterprise Standard)

![Image](https://miro.medium.com/v2/resize%3Afit%3A1200/1%2AkjBniK0bSpUxXNLcsqxKTg.jpeg)

![Image](https://devopscube.com/content/images/2025/03/image-25-23.png)

## What is a Golden Image?

A **Golden Image** is a **secure, hardened, versioned base image** approved by platform/security teams.

❌ No SSH fixes
❌ No manual installs
✅ Immutable servers
✅ Fast scaling
✅ Audit-friendly

---

## 🧱 Golden Image Layers (IMPORTANT)

### Layer 1 — OS Base (Rarely changes)

* Ubuntu / RHEL
* OS updates
* CIS hardening
* SSH hardening
* Logging + monitoring agents

### Layer 2 — Runtime (Monthly)

* Docker
* Nginx
* Node / Java / Go
* Cloud agents

### Layer 3 — App (Optional)

* Legacy apps only
* No secrets
* Not used in Kubernetes-heavy setups

---

## 🏷️ Naming Convention (Mandatory)

```
golden-ubuntu-22.04-runtime-v2025.01.15
```

---

# 4️⃣ Real Startup-Grade Repo Structure

This is **exactly** how real startups structure it 👇

```
packer-images/
├── README.md
├── Makefile
├── .github/
│   └── workflows/
│       └── packer.yml
├── images/
│   ├── ubuntu-base/
│   │   ├── main.pkr.hcl
│   │   ├── variables.pkr.hcl
│   │   └── scripts/
│   │       ├── os-update.sh
│   │       ├── hardening.sh
│   │       └── cleanup.sh
│   └── ubuntu-runtime/
│       ├── main.pkr.hcl
│       ├── variables.pkr.hcl
│       └── scripts/
│           ├── docker.sh
│           ├── nginx.sh
│           └── monitoring.sh
├── modules/
│   └── aws.pkr.hcl
└── scripts/
    └── common.sh
```

---

# 5️⃣ Build Golden Base Image (AWS)

## Prerequisite

```bash
aws configure
```

---

## `variables.pkr.hcl`

```hcl
variable "region" {
  default = "ap-south-1"
}

variable "instance_type" {
  default = "t2.micro"
}
```

---

## `main.pkr.hcl` (Base Image)

```hcl
packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1.3"
    }
  }
}

source "amazon-ebs" "ubuntu-base" {
  region        = var.region
  instance_type = var.instance_type
  ssh_username  = "ubuntu"
  ami_name      = "golden-ubuntu-base-{{timestamp}}"

  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-jammy-22.04-amd64-server-*"
      virtualization-type = "hvm"
    }
    owners      = ["099720109477"]
    most_recent = true
  }
}
```

---

## `scripts/os-update.sh`

```bash
#!/bin/bash
set -e
sudo apt update && sudo apt upgrade -y
```

## `scripts/hardening.sh`

```bash
#!/bin/bash
sudo sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
sudo systemctl restart ssh
```

## `scripts/cleanup.sh`

```bash
#!/bin/bash
sudo apt autoremove -y
sudo apt clean
```

---

## Build Block

```hcl
build {
  sources = ["source.amazon-ebs.ubuntu-base"]

  provisioner "shell" {
    scripts = [
      "scripts/os-update.sh",
      "scripts/hardening.sh",
      "scripts/cleanup.sh"
    ]
  }
}
```

---

## Run

```bash
packer init .
packer validate .
packer build .
```

✅ **Golden OS Image Ready**

---

# 6️⃣ Runtime Image (Layered on Base)

## Change source AMI

```hcl
source "amazon-ebs" "ubuntu-runtime" {
  ami_name = "golden-ubuntu-runtime-{{timestamp}}"
  source_ami = "ami-BASE_IMAGE_ID"
}
```

---

## `scripts/docker.sh`

```bash
sudo apt install -y docker.io
sudo systemctl enable docker
```

## `scripts/nginx.sh`

```bash
sudo apt install -y nginx
sudo systemctl enable nginx
```

---

## Build Runtime Image

```bash
packer build .
```

✅ Docker + Nginx baked in

---

# 7️⃣ CI/CD — GitHub Actions

![Image](https://cdn.hashnode.com/res/hashnode/image/upload/v1628578949157/M78aWQCCb.png?auto=compress%2Cformat\&format=webp)

![Image](https://miro.medium.com/1%2AkjBniK0bSpUxXNLcsqxKTg.jpeg)

### `.github/workflows/packer.yml`

```yaml
name: Build Golden Image

on:
  push:
    branches: [main]

jobs:
  packer:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: hashicorp/setup-packer@v3

      - run: packer init images/ubuntu-runtime
      - run: packer validate images/ubuntu-runtime
      - run: packer build images/ubuntu-runtime
```

---

# 8️⃣ Terraform Integration (Real Production)

```hcl
data "aws_ami" "golden" {
  most_recent = true
  owners = ["self"]

  filter {
    name   = "name"
    values = ["golden-ubuntu-runtime-*"]
  }
}

resource "aws_instance" "app" {
  ami           = data.aws_ami.golden.id
  instance_type = "t2.micro"
}
```

---

# 9️⃣ Security & Best Practices

✅ No secrets in image
✅ IAM roles only
✅ Disable SSH in prod
✅ Scan images
✅ Immutable deployments

---

# 🔥 Real Startup Workflow

```
PR → Packer Build → Scan → Approve → Terraform Apply
```

No SSH
No hotfix
No panic

---

# 🧠 One-Line Summary

> **Packer creates the server you trust.
> Terraform runs the server you trust.**

---

