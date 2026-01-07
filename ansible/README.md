# Ansible Documentation - Complete Guide

## Overview

This directory contains comprehensive Ansible documentation covering fundamentals, authentication, playbooks, roles, and advanced topics. Each file includes detailed explanations, workflow diagrams, and practical examples.

## Documentation Structure

### Core Topics

1. **[Ansible Fundamentals](./01-Ansible-Fundamentals.md)**
   - What is Ansible and why use it
   - Ansible vs Shell Scripts vs Python
   - Architecture and core components
   - Installation on multiple platforms
   - VS Code IDE setup and configuration
   - Project structure and best practices

2. **[SSH Authentication and Inventory](./02-SSH-Authentication-and-Inventory.md)**
   - SSH key-based authentication
   - Passwordless authentication setup
   - SSH agent configuration
   - Troubleshooting SSH issues
   - Ansible inventory (INI and YAML)
   - Dynamic inventory (AWS, Azure, GCP)
   - Inventory best practices

3. **[Ansible Playbooks](./ansible-playbook-examples.md)** *(Already created)*
   - Basic playbook examples
   - Web server setup (Nginx)
   - Application deployment (Node.js)
   - Database configuration (PostgreSQL)
   - Security hardening
   - Monitoring setup
   - Best practices

4. **[Ad-hoc Commands](./03-Adhoc-Commands.md)** *(To be created)*
   - Understanding ad-hoc commands
   - Common use cases
   - Module examples
   - When to use vs playbooks

5. **[Ansible Roles](./04-Ansible-Roles.md)** *(To be created)*
   - What are roles and why use them
   - Role structure and organization
   - Creating custom roles
   - Ansible Galaxy
   - Role dependencies
   - Best practices

6. **[Variables and Precedence](./05-Variables-and-Precedence.md)** *(To be created)*
   - Variable types and scope
   - Variable precedence order
   - Jinja2 templating
   - Facts and magic variables
   - Registered variables

7. **[Conditionals and Loops](./06-Conditionals-and-Loops.md)** *(To be created)*
   - When statements
   - Loop types (with_items, loop, etc.)
   - Conditional loops
   - Failed_when and changed_when

8. **[Error Handling](./07-Error-Handling.md)** *(To be created)*
   - Handling failures
   - Blocks and rescue
   - Ignore errors
   - Retry logic
   - Debugging techniques

9. **[Ansible Vault](./08-Ansible-Vault.md)** *(To be created)*
   - Encrypting sensitive data
   - Vault commands
   - Best practices for secrets
   - Integration with CI/CD

10. **[Advanced Topics](./09-Advanced-Topics.md)** *(To be created)*
    - Collections
    - Custom modules
    - Plugins
    - Ansible Tower/AWX
    - Network automation

## Quick Start

### Installation

```bash
# Ubuntu/Debian
sudo apt update
sudo apt install ansible

# CentOS/RHEL
sudo yum install epel-release
sudo yum install ansible

# macOS
brew install ansible

# Using pip
pip install ansible
```

### Basic Usage

```bash
# Test connection
ansible all -m ping

# Run ad-hoc command
ansible all -m shell -a "uptime"

# Run playbook
ansible-playbook playbook.yml

# Check syntax
ansible-playbook playbook.yml --syntax-check

# Dry run
ansible-playbook playbook.yml --check
```

## Learning Path

### Beginner (Week 1-2)
1. **Start with Fundamentals**
   - Understand Ansible architecture
   - Install and configure Ansible
   - Set up SSH authentication
   - Learn inventory basics

2. **Practice Ad-hoc Commands**
   - Run simple commands
   - Explore common modules
   - Understand module documentation

3. **Write First Playbook**
   - Learn YAML syntax
   - Create simple playbooks
   - Understand tasks and modules

### Intermediate (Week 3-4)
4. **Master Playbooks**
   - Complex playbook structures
   - Use handlers and notifications
   - Implement error handling

5. **Learn Roles**
   - Create custom roles
   - Use Ansible Galaxy
   - Organize code with roles

6. **Work with Variables**
   - Understand variable precedence
   - Use Jinja2 templates
   - Implement conditionals and loops

### Advanced (Week 5-6)
7. **Security and Vault**
   - Encrypt sensitive data
   - Manage secrets properly
   - Implement security best practices

8. **Advanced Features**
   - Dynamic inventory
   - Custom modules
   - Collections and plugins

9. **Production Deployment**
   - CI/CD integration
   - Ansible Tower/AWX
   - Monitoring and logging

## Common Use Cases

### 1. Server Configuration

```yaml
---
- name: Configure web servers
  hosts: webservers
  become: yes
  tasks:
    - name: Install packages
      apt:
        name:
          - nginx
          - python3
          - git
        state: present
        
    - name: Start nginx
      service:
        name: nginx
        state: started
        enabled: yes
```

### 2. Application Deployment

```yaml
---
- name: Deploy application
  hosts: appservers
  tasks:
    - name: Clone repository
      git:
        repo: https://github.com/user/app.git
        dest: /opt/app
        version: main
        
    - name: Install dependencies
      pip:
        requirements: /opt/app/requirements.txt
        
    - name: Restart application
      systemd:
        name: myapp
        state: restarted
```

### 3. Database Setup

```yaml
---
- name: Setup PostgreSQL
  hosts: databases
  become: yes
  tasks:
    - name: Install PostgreSQL
      apt:
        name: postgresql
        state: present
        
    - name: Create database
      postgresql_db:
        name: myapp
        state: present
      become_user: postgres
```

## Ansible Modules Reference

### System Modules

| Module | Purpose | Example |
|--------|---------|---------|
| `apt` | Package management (Debian) | `apt: name=nginx state=present` |
| `yum` | Package management (RedHat) | `yum: name=httpd state=latest` |
| `service` | Service management | `service: name=nginx state=started` |
| `systemd` | Systemd service management | `systemd: name=nginx enabled=yes` |
| `user` | User management | `user: name=john state=present` |
| `group` | Group management | `group: name=developers state=present` |
| `file` | File/directory management | `file: path=/tmp/test state=directory` |
| `copy` | Copy files | `copy: src=file.txt dest=/tmp/` |
| `template` | Jinja2 templates | `template: src=config.j2 dest=/etc/app/config` |

### Command Modules

| Module | Purpose | Example |
|--------|---------|---------|
| `command` | Execute commands | `command: /usr/bin/uptime` |
| `shell` | Execute shell commands | `shell: echo $HOME` |
| `script` | Run local script on remote | `script: /tmp/script.sh` |
| `raw` | Execute raw commands | `raw: apt-get update` |

### Cloud Modules

| Module | Purpose | Example |
|--------|---------|---------|
| `ec2` | AWS EC2 instances | `ec2: instance_type=t2.micro` |
| `s3_bucket` | AWS S3 buckets | `s3_bucket: name=mybucket state=present` |
| `azure_rm_virtualmachine` | Azure VMs | `azure_rm_virtualmachine: name=myvm` |
| `gcp_compute_instance` | GCP instances | `gcp_compute_instance: name=myinstance` |

## Best Practices

### 1. Project Structure

```
ansible-project/
├── ansible.cfg
├── inventory/
│   ├── production/
│   │   ├── hosts.ini
│   │   └── group_vars/
│   └── staging/
│       ├── hosts.ini
│       └── group_vars/
├── playbooks/
│   ├── site.yml
│   ├── webservers.yml
│   └── databases.yml
├── roles/
│   ├── common/
│   ├── webserver/
│   └── database/
├── group_vars/
│   └── all.yml
├── host_vars/
└── files/
```

### 2. Naming Conventions

- **Playbooks**: Use descriptive names (`deploy-webapp.yml`)
- **Roles**: Use lowercase with hyphens (`web-server`)
- **Variables**: Use snake_case (`http_port`)
- **Tasks**: Start with verb (`Install nginx`, `Copy configuration`)

### 3. Idempotency

```yaml
# Good - Idempotent
- name: Ensure nginx is installed
  apt:
    name: nginx
    state: present

# Bad - Not idempotent
- name: Install nginx
  shell: apt-get install nginx
```

### 4. Use Roles for Reusability

```yaml
# Instead of repeating tasks
- hosts: webservers
  roles:
    - common
    - webserver
    - monitoring
```

### 5. Encrypt Sensitive Data

```bash
# Encrypt file
ansible-vault encrypt secrets.yml

# Use in playbook
ansible-playbook playbook.yml --ask-vault-pass
```

### 6. Test Before Production

```bash
# Syntax check
ansible-playbook playbook.yml --syntax-check

# Dry run
ansible-playbook playbook.yml --check

# Run on staging first
ansible-playbook -i inventory/staging playbook.yml
```

## Troubleshooting

### Common Issues

**1. SSH Connection Failed**
```bash
# Check SSH connectivity
ssh user@host

# Verify inventory
ansible-inventory --list

# Test with verbose output
ansible all -m ping -vvv
```

**2. Module Not Found**
```bash
# Install required collection
ansible-galaxy collection install community.general

# Verify module exists
ansible-doc module_name
```

**3. Permission Denied**
```bash
# Use become for privilege escalation
ansible-playbook playbook.yml --become --ask-become-pass

# Or in playbook
become: yes
become_user: root
```

**4. Variable Not Defined**
```bash
# Check variable precedence
ansible-playbook playbook.yml -e "var_name=value"

# Debug variables
- debug:
    var: variable_name
```

## Useful Commands

### Inventory

```bash
# List all hosts
ansible all --list-hosts

# List hosts in group
ansible webservers --list-hosts

# Show inventory graph
ansible-inventory --graph

# Show host variables
ansible-inventory --host hostname
```

### Playbooks

```bash
# Run playbook
ansible-playbook playbook.yml

# Limit to specific hosts
ansible-playbook playbook.yml --limit webservers

# Start at specific task
ansible-playbook playbook.yml --start-at-task="Install nginx"

# Use tags
ansible-playbook playbook.yml --tags "configuration"

# Skip tags
ansible-playbook playbook.yml --skip-tags "testing"
```

### Ad-hoc Commands

```bash
# Run command on all hosts
ansible all -m command -a "uptime"

# Copy file
ansible all -m copy -a "src=/tmp/file dest=/tmp/file"

# Install package
ansible all -m apt -a "name=nginx state=present" --become

# Restart service
ansible all -m service -a "name=nginx state=restarted" --become
```

### Vault

```bash
# Create encrypted file
ansible-vault create secrets.yml

# Edit encrypted file
ansible-vault edit secrets.yml

# Encrypt existing file
ansible-vault encrypt file.yml

# Decrypt file
ansible-vault decrypt file.yml

# View encrypted file
ansible-vault view secrets.yml

# Change password
ansible-vault rekey secrets.yml
```

## Resources

### Official Documentation
- [Ansible Documentation](https://docs.ansible.com/)
- [Ansible Galaxy](https://galaxy.ansible.com/)
- [Ansible Module Index](https://docs.ansible.com/ansible/latest/collections/index_module.html)

### Community
- [Ansible GitHub](https://github.com/ansible/ansible)
- [Ansible Forum](https://forum.ansible.com/)
- [Reddit r/ansible](https://www.reddit.com/r/ansible/)

### Learning Resources
- [Ansible for DevOps](https://www.ansiblefordevops.com/)
- [Ansible Best Practices](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html)
- [Ansible Examples](https://github.com/ansible/ansible-examples)

## Contributing

When adding new Ansible documentation:
1. Follow the established format
2. Include workflow diagrams
3. Provide practical examples
4. Add troubleshooting sections
5. Include best practices
6. Update this README

## Summary

This Ansible documentation provides:
- **Comprehensive coverage** from basics to advanced topics
- **Visual diagrams** for better understanding
- **Practical examples** for real-world scenarios
- **Best practices** for production use
- **Troubleshooting guides** for common issues
- **Quick references** for commands and modules

Perfect for DevOps engineers, system administrators, and anyone automating infrastructure with Ansible.

---

**Last Updated**: January 6, 2026  
**Status**: ✅ Core topics documented with diagrams  
**Next**: Complete remaining topics (Ad-hoc, Roles, Variables, Vault, Advanced)