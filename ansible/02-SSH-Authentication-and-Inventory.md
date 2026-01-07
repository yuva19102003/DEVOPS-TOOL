# SSH Authentication and Ansible Inventory - Complete Guide

## Overview

This guide covers SSH key-based authentication setup and Ansible inventory management, which are fundamental for secure and efficient Ansible operations.

## Table of Contents

1. [SSH Key Authentication](#ssh-key-authentication)
2. [Passwordless Authentication Setup](#passwordless-authentication-setup)
3. [Ansible Inventory](#ansible-inventory)
4. [Inventory Best Practices](#inventory-best-practices)

---

## SSH Key Authentication

### Why Use SSH Keys?

- **More Secure**: Stronger than passwords
- **Convenient**: No password prompts
- **Automation-Friendly**: Required for automated tasks
- **Auditable**: Track which keys access which systems

### SSH Authentication Workflow

```
┌─────────────────────────────────────────────────────────────────┐
│              SSH Key Authentication Flow                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  Control Node (Your Machine)                                    │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │                                                           │  │
│  │  ~/.ssh/                                                  │  │
│  │  ├── id_rsa (Private Key) 🔐                            │  │
│  │  └── id_rsa.pub (Public Key) 🔓                         │  │
│  │                                                           │  │
│  │  $ ssh-copy-id user@remote-host                          │  │
│  └──────────────────────┬───────────────────────────────────┘  │
│                         │                                       │
│                         │ Copies public key                     │
│                         ▼                                       │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  Remote Host (Managed Node)                              │  │
│  │                                                           │  │
│  │  ~/.ssh/authorized_keys                                  │  │
│  │  ┌────────────────────────────────────────────────────┐  │  │
│  │  │  ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQ...        │  │  │
│  │  │  (Your public key stored here)                     │  │  │
│  │  └────────────────────────────────────────────────────┘  │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                  │
│  Authentication Process:                                        │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  1. Client initiates SSH connection                      │  │
│  │  2. Server sends challenge                               │  │
│  │  3. Client signs challenge with private key              │  │
│  │  4. Server verifies with public key                      │  │
│  │  5. Access granted ✅                                    │  │
│  └──────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

---

## Passwordless Authentication Setup

### Step 1: Check for Existing SSH Keys

```bash
# Check if SSH keys exist
ls -la ~/.ssh/

# Look for these files:
# - id_rsa (private key)
# - id_rsa.pub (public key)
# - id_ed25519 (newer algorithm)
# - id_ed25519.pub
```

### Step 2: Generate SSH Key Pair

If you don't have SSH keys, generate them:

```bash
# Generate RSA key (traditional, widely supported)
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"

# Or generate Ed25519 key (modern, more secure, faster)
ssh-keygen -t ed25519 -C "your_email@example.com"

# Follow the prompts:
# - Press Enter to save to default location (~/.ssh/id_rsa)
# - Enter passphrase (optional but recommended)
# - Confirm passphrase
```

**Key Generation Options**:

| Option | Description |
|--------|-------------|
| `-t rsa` | Key type (rsa, ed25519, ecdsa) |
| `-b 4096` | Key size in bits (RSA: 2048-4096) |
| `-C "comment"` | Comment (usually email) |
| `-f filename` | Custom filename |
| `-N "passphrase"` | Set passphrase non-interactively |

### Step 3: Start SSH Agent

The SSH agent manages your keys and passphrases:

```bash
# Start SSH agent
eval "$(ssh-agent -s)"

# Output: Agent pid 12345
```

### Step 4: Add SSH Key to Agent

```bash
# Add your SSH private key to the agent
ssh-add ~/.ssh/id_rsa

# Or for Ed25519
ssh-add ~/.ssh/id_ed25519

# Verify keys are loaded
ssh-add -l

# Output: 4096 SHA256:... your_email@example.com (RSA)
```

### Step 5: Copy Public Key to Remote Host

#### Method 1: Using ssh-copy-id (Recommended)

```bash
# Copy public key to remote host
ssh-copy-id username@remote-host

# Or specify key file
ssh-copy-id -i ~/.ssh/id_rsa.pub username@remote-host

# Or specify port
ssh-copy-id -i ~/.ssh/id_rsa.pub -p 2222 username@remote-host
```

#### Method 2: Manual Copy

```bash
# Display your public key
cat ~/.ssh/id_rsa.pub

# SSH to remote host and add key manually
ssh username@remote-host

# On remote host, create .ssh directory if it doesn't exist
mkdir -p ~/.ssh
chmod 700 ~/.ssh

# Add your public key to authorized_keys
echo "your-public-key-content" >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

# Exit remote host
exit
```

#### Method 3: Using Ansible

```bash
# Create a temporary inventory
cat > temp_inventory.ini << EOF
[servers]
remote-host ansible_user=username ansible_ssh_pass=your_password
EOF

# Use Ansible to copy SSH key
ansible servers -i temp_inventory.ini -m authorized_key -a "user=username key='{{ lookup('file', '~/.ssh/id_rsa.pub') }}' state=present" --ask-pass

# Remove temporary inventory
rm temp_inventory.ini
```

### Step 6: Test SSH Connection

```bash
# Test passwordless SSH
ssh username@remote-host

# Should connect without password prompt

# Test with verbose output for troubleshooting
ssh -v username@remote-host
```

### Troubleshooting SSH Authentication

#### Error: "No identities found"

```bash
# This means SSH agent doesn't have keys loaded

# Solution 1: Check for existing keys
ls ~/.ssh/

# Solution 2: Generate new key if needed
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"

# Solution 3: Start SSH agent
eval "$(ssh-agent -s)"

# Solution 4: Add key to agent
ssh-add ~/.ssh/id_rsa

# Solution 5: Verify keys are loaded
ssh-add -l
```

#### Error: "Permission denied (publickey)"

```bash
# Check permissions on remote host
ssh username@remote-host "ls -la ~/.ssh/"

# Correct permissions should be:
# ~/.ssh/ = 700 (drwx------)
# ~/.ssh/authorized_keys = 600 (-rw-------)

# Fix permissions on remote host
ssh username@remote-host "chmod 700 ~/.ssh && chmod 600 ~/.ssh/authorized_keys"
```

#### Error: "Host key verification failed"

```bash
# Remove old host key
ssh-keygen -R remote-host

# Or disable strict host key checking (not recommended for production)
ssh -o StrictHostKeyChecking=no username@remote-host
```

### SSH Configuration File

Create `~/.ssh/config` for easier management:

```bash
# Create SSH config file
cat > ~/.ssh/config << EOF
# Default settings
Host *
    ServerAliveInterval 60
    ServerAliveCountMax 3
    StrictHostKeyChecking ask
    UserKnownHostsFile ~/.ssh/known_hosts

# Production servers
Host prod-web-*
    User ubuntu
    IdentityFile ~/.ssh/prod_key
    Port 22

# Staging servers
Host staging-*
    User ubuntu
    IdentityFile ~/.ssh/staging_key
    Port 22

# Specific host
Host web1
    HostName 192.168.1.10
    User admin
    IdentityFile ~/.ssh/id_rsa
    Port 2222

# Jump host (bastion)
Host internal-server
    HostName 10.0.1.100
    User ubuntu
    ProxyJump bastion.example.com
EOF

# Set correct permissions
chmod 600 ~/.ssh/config
```

---

## Ansible Inventory

### What is Inventory?

Ansible inventory defines the hosts and groups of hosts that Ansible manages. It can be static (INI or YAML files) or dynamic (scripts or plugins).

### Inventory Structure

```
┌─────────────────────────────────────────────────────────────────┐
│                  Ansible Inventory Structure                     │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  Inventory File (inventory.ini)                                 │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │                                                           │  │
│  │  [webservers]                    ← Group                 │  │
│  │  web1.example.com                ← Host                  │  │
│  │  web2.example.com                                        │  │
│  │                                                           │  │
│  │  [databases]                     ← Group                 │  │
│  │  db1.example.com                                         │  │
│  │  db2.example.com                                         │  │
│  │                                                           │  │
│  │  [loadbalancers]                 ← Group                 │  │
│  │  lb1.example.com                                         │  │
│  │                                                           │  │
│  │  [production:children]           ← Parent Group          │  │
│  │  webservers                                              │  │
│  │  databases                                               │  │
│  │  loadbalancers                                           │  │
│  │                                                           │  │
│  │  [all:vars]                      ← Group Variables       │  │
│  │  ansible_user=ubuntu                                     │  │
│  │  ansible_ssh_private_key_file=~/.ssh/id_rsa             │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                  │
│  Hierarchy:                                                      │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  all (implicit group)                                     │  │
│  │  ├── production                                           │  │
│  │  │   ├── webservers                                      │  │
│  │  │   │   ├── web1.example.com                           │  │
│  │  │   │   └── web2.example.com                           │  │
│  │  │   ├── databases                                       │  │
│  │  │   │   ├── db1.example.com                            │  │
│  │  │   │   └── db2.example.com                            │  │
│  │  │   └── loadbalancers                                   │  │
│  │  │       └── lb1.example.com                            │  │
│  │  └── ungrouped (hosts not in any group)                 │  │
│  └──────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

### Basic Inventory (INI Format)

```ini
# inventory.ini

# Ungrouped hosts
standalone.example.com

# Web servers group
[webservers]
web1.example.com
web2.example.com
web3.example.com

# Database servers group
[databases]
db1.example.com
db2.example.com

# Load balancers group
[loadbalancers]
lb1.example.com

# Parent group containing multiple groups
[production:children]
webservers
databases
loadbalancers

# Variables for all hosts
[all:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=~/.ssh/id_rsa
ansible_python_interpreter=/usr/bin/python3

# Variables for webservers group
[webservers:vars]
http_port=80
https_port=443

# Variables for databases group
[databases:vars]
db_port=5432
```

### Advanced Inventory (INI Format)

```ini
# inventory.ini

# Hosts with inline variables
[webservers]
web1.example.com ansible_host=192.168.1.10 ansible_port=22
web2.example.com ansible_host=192.168.1.11 ansible_port=2222
web3.example.com ansible_host=192.168.1.12 ansible_user=admin

# Hosts with ranges
[databases]
db[1:3].example.com

# Equivalent to:
# db1.example.com
# db2.example.com
# db3.example.com

# Hosts with patterns
[appservers]
app-[a:c].example.com

# Equivalent to:
# app-a.example.com
# app-b.example.com
# app-c.example.com

# Local connection
[local]
localhost ansible_connection=local

# Windows hosts
[windows]
win1.example.com ansible_connection=winrm ansible_winrm_transport=ntlm
win2.example.com ansible_connection=winrm ansible_port=5986

# Docker containers
[containers]
container1 ansible_connection=docker
container2 ansible_connection=docker

# Multiple environments
[staging:children]
staging_web
staging_db

[staging_web]
staging-web[1:2].example.com

[staging_db]
staging-db1.example.com
```

### YAML Inventory Format

```yaml
# inventory.yml

all:
  children:
    production:
      children:
        webservers:
          hosts:
            web1.example.com:
              ansible_host: 192.168.1.10
              http_port: 80
            web2.example.com:
              ansible_host: 192.168.1.11
              http_port: 8080
          vars:
            ansible_user: ubuntu
            
        databases:
          hosts:
            db1.example.com:
              ansible_host: 192.168.1.20
            db2.example.com:
              ansible_host: 192.168.1.21
          vars:
            db_port: 5432
            
        loadbalancers:
          hosts:
            lb1.example.com:
              ansible_host: 192.168.1.30
              
    staging:
      children:
        staging_web:
          hosts:
            staging-web1.example.com:
        staging_db:
          hosts:
            staging-db1.example.com:
            
  vars:
    ansible_ssh_private_key_file: ~/.ssh/id_rsa
    ansible_python_interpreter: /usr/bin/python3
```

### Inventory Commands

```bash
# List all hosts
ansible all --list-hosts

# List hosts in specific group
ansible webservers --list-hosts

# List all groups
ansible localhost -m debug -a "var=groups.keys()"

# Show inventory graph
ansible-inventory --graph

# Show inventory in JSON format
ansible-inventory --list

# Show inventory in YAML format
ansible-inventory --list -y

# Show host variables
ansible-inventory --host web1.example.com

# Verify inventory
ansible-inventory -i inventory.ini --list
```

### Dynamic Inventory

Dynamic inventory allows Ansible to query external sources for host information.

#### AWS EC2 Dynamic Inventory

```bash
# Install boto3
pip install boto3

# Create aws_ec2.yml
cat > aws_ec2.yml << EOF
plugin: aws_ec2
regions:
  - us-east-1
  - us-west-2
filters:
  tag:Environment: production
keyed_groups:
  - key: tags.Role
    prefix: role
  - key: tags.Environment
    prefix: env
hostnames:
  - tag:Name
  - private-ip-address
compose:
  ansible_host: public_ip_address
EOF

# Use dynamic inventory
ansible-inventory -i aws_ec2.yml --graph
ansible all -i aws_ec2.yml -m ping
```

---

## Inventory Best Practices

### 1. Organize by Environment

```
inventory/
├── production/
│   ├── hosts.ini
│   └── group_vars/
│       ├── all.yml
│       ├── webservers.yml
│       └── databases.yml
├── staging/
│   ├── hosts.ini
│   └── group_vars/
│       ├── all.yml
│       ├── webservers.yml
│       └── databases.yml
└── development/
    ├── hosts.ini
    └── group_vars/
        └── all.yml
```

### 2. Use Group Variables

```yaml
# group_vars/webservers.yml
---
http_port: 80
https_port: 443
max_connections: 1000
document_root: /var/www/html
```

### 3. Use Host Variables

```yaml
# host_vars/web1.example.com.yml
---
ansible_host: 192.168.1.10
server_id: 1
backup_enabled: true
```

### 4. Separate Sensitive Data

```yaml
# group_vars/all/vars.yml (public)
---
app_name: myapp
app_port: 8080

# group_vars/all/vault.yml (encrypted)
---
db_password: !vault |
          $ANSIBLE_VAULT;1.1;AES256
          ...encrypted content...
```

### 5. Use Meaningful Group Names

```ini
# Good
[web_production]
[db_staging]
[cache_development]

# Bad
[group1]
[servers]
[misc]
```

### 6. Document Your Inventory

```ini
# inventory.ini
# Production Infrastructure
# Last updated: 2026-01-06
# Contact: devops@example.com

# Web tier - handles HTTP/HTTPS traffic
[webservers]
web1.example.com  # Primary web server
web2.example.com  # Secondary web server

# Database tier - PostgreSQL cluster
[databases]
db1.example.com   # Primary database
db2.example.com   # Replica database
```

---

## Testing Inventory

### Test Connectivity

```bash
# Ping all hosts
ansible all -m ping

# Ping specific group
ansible webservers -m ping

# Ping with specific inventory
ansible all -i inventory/production/hosts.ini -m ping
```

### Gather Facts

```bash
# Gather facts from all hosts
ansible all -m setup

# Gather specific facts
ansible all -m setup -a "filter=ansible_distribution*"

# Save facts to file
ansible all -m setup --tree /tmp/facts
```

### Run Ad-hoc Commands

```bash
# Check disk space
ansible all -m shell -a "df -h"

# Check memory
ansible all -m shell -a "free -m"

# Check uptime
ansible all -m command -a "uptime"

# List users
ansible all -m shell -a "cat /etc/passwd | grep /home"
```

---

## Summary

- **SSH Keys**: More secure and automation-friendly than passwords
- **SSH Agent**: Manages keys and passphrases
- **ssh-copy-id**: Easiest way to copy public keys
- **Inventory**: Defines hosts and groups for Ansible
- **Formats**: INI (simple) or YAML (structured)
- **Dynamic Inventory**: Query external sources (AWS, Azure, GCP)
- **Best Practices**: Organize by environment, use variables, document

Proper SSH authentication and inventory management are foundational for successful Ansible automation.