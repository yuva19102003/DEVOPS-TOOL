# Ansible Playbook Examples - Complete Guide

## Overview

This guide provides comprehensive Ansible playbook examples for common DevOps tasks, from basic server configuration to complex application deployments.

## Table of Contents

1. [Basic Playbooks](#basic-playbooks)
2. [Web Server Setup](#web-server-setup)
3. [Application Deployment](#application-deployment)
4. [Database Configuration](#database-configuration)
5. [Security Hardening](#security-hardening)
6. [Monitoring Setup](#monitoring-setup)

## Basic Playbooks

### 1. System Update Playbook

```yaml
---
- name: Update and upgrade all packages
  hosts: all
  become: yes
  tasks:
    - name: Update apt cache (Debian/Ubuntu)
      apt:
        update_cache: yes
        cache_valid_time: 3600
      when: ansible_os_family == "Debian"

    - name: Upgrade all packages (Debian/Ubuntu)
      apt:
        upgrade: dist
        autoremove: yes
        autoclean: yes
      when: ansible_os_family == "Debian"

    - name: Update yum cache (RedHat/CentOS)
      yum:
        update_cache: yes
      when: ansible_os_family == "RedHat"

    - name: Upgrade all packages (RedHat/CentOS)
      yum:
        name: '*'
        state: latest
      when: ansible_os_family == "RedHat"

    - name: Check if reboot is required
      stat:
        path: /var/run/reboot-required
      register: reboot_required
      when: ansible_os_family == "Debian"

    - name: Reboot if required
      reboot:
        msg: "Reboot initiated by Ansible"
        connect_timeout: 5
        reboot_timeout: 300
      when: reboot_required.stat.exists | default(false)
```

### 2. User Management Playbook

```yaml
---
- name: Manage users and SSH keys
  hosts: all
  become: yes
  vars:
    users:
      - name: devops
        groups: sudo,docker
        shell: /bin/bash
        ssh_key: "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQ..."
      - name: developer
        groups: docker
        shell: /bin/bash
        ssh_key: "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQ..."

  tasks:
    - name: Create user groups
      group:
        name: "{{ item }}"
        state: present
      loop:
        - docker
        - developers

    - name: Create users
      user:
        name: "{{ item.name }}"
        groups: "{{ item.groups }}"
        shell: "{{ item.shell }}"
        create_home: yes
        state: present
      loop: "{{ users }}"

    - name: Set up SSH keys
      authorized_key:
        user: "{{ item.name }}"
        key: "{{ item.ssh_key }}"
        state: present
      loop: "{{ users }}"

    - name: Configure sudo without password
      lineinfile:
        path: /etc/sudoers.d/{{ item.name }}
        line: "{{ item.name }} ALL=(ALL) NOPASSWD:ALL"
        create: yes
        mode: '0440'
        validate: 'visudo -cf %s'
      loop: "{{ users }}"
      when: "'sudo' in item.groups"
```

## Web Server Setup

### 3. Nginx Web Server Playbook

```yaml
---
- name: Install and configure Nginx
  hosts: webservers
  become: yes
  vars:
    nginx_port: 80
    nginx_ssl_port: 443
    domain_name: example.com
    ssl_certificate_path: /etc/ssl/certs/{{ domain_name }}.crt
    ssl_key_path: /etc/ssl/private/{{ domain_name }}.key

  tasks:
    - name: Install Nginx
      apt:
        name: nginx
        state: present
        update_cache: yes
      when: ansible_os_family == "Debian"

    - name: Install Nginx (RedHat)
      yum:
        name: nginx
        state: present
      when: ansible_os_family == "RedHat"

    - name: Create web root directory
      file:
        path: /var/www/{{ domain_name }}
        state: directory
        owner: www-data
        group: www-data
        mode: '0755'

    - name: Deploy index.html
      copy:
        content: |
          <!DOCTYPE html>
          <html>
          <head>
              <title>Welcome to {{ domain_name }}</title>
          </head>
          <body>
              <h1>Success! Nginx is configured.</h1>
              <p>Server: {{ ansible_hostname }}</p>
          </body>
          </html>
        dest: /var/www/{{ domain_name }}/index.html
        owner: www-data
        group: www-data
        mode: '0644'

    - name: Configure Nginx site
      template:
        src: nginx-site.conf.j2
        dest: /etc/nginx/sites-available/{{ domain_name }}
        owner: root
        group: root
        mode: '0644'
      notify: Reload Nginx

    - name: Enable Nginx site
      file:
        src: /etc/nginx/sites-available/{{ domain_name }}
        dest: /etc/nginx/sites-enabled/{{ domain_name }}
        state: link
      notify: Reload Nginx

    - name: Remove default Nginx site
      file:
        path: /etc/nginx/sites-enabled/default
        state: absent
      notify: Reload Nginx

    - name: Ensure Nginx is started and enabled
      systemd:
        name: nginx
        state: started
        enabled: yes

    - name: Configure firewall for HTTP/HTTPS
      ufw:
        rule: allow
        port: "{{ item }}"
        proto: tcp
      loop:
        - "{{ nginx_port }}"
        - "{{ nginx_ssl_port }}"
      when: ansible_os_family == "Debian"

  handlers:
    - name: Reload Nginx
      systemd:
        name: nginx
        state: reloaded
```

### Nginx Configuration Template (nginx-site.conf.j2)

```nginx
server {
    listen {{ nginx_port }};
    listen [::]:{{ nginx_port }};
    server_name {{ domain_name }} www.{{ domain_name }};

    root /var/www/{{ domain_name }};
    index index.html index.htm;

    location / {
        try_files $uri $uri/ =404;
    }

    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;

    # Logging
    access_log /var/log/nginx/{{ domain_name }}_access.log;
    error_log /var/log/nginx/{{ domain_name }}_error.log;
}

{% if ssl_certificate_path is defined %}
server {
    listen {{ nginx_ssl_port }} ssl http2;
    listen [::]:{{ nginx_ssl_port }} ssl http2;
    server_name {{ domain_name }} www.{{ domain_name }};

    ssl_certificate {{ ssl_certificate_path }};
    ssl_certificate_key {{ ssl_key_path }};
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;

    root /var/www/{{ domain_name }};
    index index.html index.htm;

    location / {
        try_files $uri $uri/ =404;
    }

    # Security headers
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;

    access_log /var/log/nginx/{{ domain_name }}_ssl_access.log;
    error_log /var/log/nginx/{{ domain_name }}_ssl_error.log;
}
{% endif %}
```

## Application Deployment

### 4. Node.js Application Deployment

```yaml
---
- name: Deploy Node.js application
  hosts: appservers
  become: yes
  vars:
    app_name: myapp
    app_user: nodejs
    app_directory: /opt/{{ app_name }}
    node_version: "20.x"
    app_port: 3000
    git_repo: https://github.com/username/myapp.git
    git_branch: main

  tasks:
    - name: Install Node.js repository
      shell: curl -fsSL https://deb.nodesource.com/setup_{{ node_version }} | bash -
      args:
        creates: /etc/apt/sources.list.d/nodesource.list

    - name: Install Node.js and npm
      apt:
        name:
          - nodejs
          - git
        state: present
        update_cache: yes

    - name: Create application user
      user:
        name: "{{ app_user }}"
        system: yes
        shell: /bin/bash
        home: "{{ app_directory }}"
        create_home: no

    - name: Create application directory
      file:
        path: "{{ app_directory }}"
        state: directory
        owner: "{{ app_user }}"
        group: "{{ app_user }}"
        mode: '0755'

    - name: Clone application repository
      git:
        repo: "{{ git_repo }}"
        dest: "{{ app_directory }}"
        version: "{{ git_branch }}"
        force: yes
      become_user: "{{ app_user }}"
      notify: Restart application

    - name: Install npm dependencies
      npm:
        path: "{{ app_directory }}"
        production: yes
      become_user: "{{ app_user }}"
      notify: Restart application

    - name: Create .env file
      template:
        src: app.env.j2
        dest: "{{ app_directory }}/.env"
        owner: "{{ app_user }}"
        group: "{{ app_user }}"
        mode: '0600'
      notify: Restart application

    - name: Create systemd service file
      template:
        src: nodejs-app.service.j2
        dest: /etc/systemd/system/{{ app_name }}.service
        owner: root
        group: root
        mode: '0644'
      notify:
        - Reload systemd
        - Restart application

    - name: Enable and start application service
      systemd:
        name: "{{ app_name }}"
        enabled: yes
        state: started

  handlers:
    - name: Reload systemd
      systemd:
        daemon_reload: yes

    - name: Restart application
      systemd:
        name: "{{ app_name }}"
        state: restarted
```

### Systemd Service Template (nodejs-app.service.j2)

```ini
[Unit]
Description={{ app_name }} Node.js Application
After=network.target

[Service]
Type=simple
User={{ app_user }}
WorkingDirectory={{ app_directory }}
ExecStart=/usr/bin/node {{ app_directory }}/server.js
Restart=always
RestartSec=10
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier={{ app_name }}
Environment=NODE_ENV=production
Environment=PORT={{ app_port }}

[Install]
WantedBy=multi-user.target
```

## Database Configuration

### 5. PostgreSQL Setup Playbook

```yaml
---
- name: Install and configure PostgreSQL
  hosts: dbservers
  become: yes
  vars:
    postgres_version: "15"
    postgres_databases:
      - name: appdb
        owner: appuser
    postgres_users:
      - name: appuser
        password: "{{ vault_postgres_password }}"
        priv: "appdb:ALL"

  tasks:
    - name: Install PostgreSQL
      apt:
        name:
          - "postgresql-{{ postgres_version }}"
          - postgresql-contrib
          - python3-psycopg2
        state: present
        update_cache: yes

    - name: Ensure PostgreSQL is started and enabled
      systemd:
        name: postgresql
        state: started
        enabled: yes

    - name: Create PostgreSQL users
      postgresql_user:
        name: "{{ item.name }}"
        password: "{{ item.password }}"
        state: present
      loop: "{{ postgres_users }}"
      become_user: postgres

    - name: Create PostgreSQL databases
      postgresql_db:
        name: "{{ item.name }}"
        owner: "{{ item.owner }}"
        encoding: UTF8
        lc_collate: en_US.UTF-8
        lc_ctype: en_US.UTF-8
        template: template0
        state: present
      loop: "{{ postgres_databases }}"
      become_user: postgres

    - name: Configure PostgreSQL authentication
      postgresql_pg_hba:
        dest: /etc/postgresql/{{ postgres_version }}/main/pg_hba.conf
        contype: host
        databases: all
        users: all
        source: 0.0.0.0/0
        method: md5
      notify: Restart PostgreSQL

    - name: Configure PostgreSQL to listen on all interfaces
      lineinfile:
        path: /etc/postgresql/{{ postgres_version }}/main/postgresql.conf
        regexp: '^#?listen_addresses'
        line: "listen_addresses = '*'"
      notify: Restart PostgreSQL

    - name: Configure firewall for PostgreSQL
      ufw:
        rule: allow
        port: 5432
        proto: tcp

  handlers:
    - name: Restart PostgreSQL
      systemd:
        name: postgresql
        state: restarted
```

## Security Hardening

### 6. Server Security Hardening Playbook

```yaml
---
- name: Harden server security
  hosts: all
  become: yes
  vars:
    ssh_port: 22
    allowed_ssh_users: ["devops", "admin"]

  tasks:
    - name: Update all packages
      apt:
        upgrade: dist
        update_cache: yes
        cache_valid_time: 3600

    - name: Install security packages
      apt:
        name:
          - ufw
          - fail2ban
          - unattended-upgrades
          - apt-listchanges
        state: present

    - name: Configure SSH - Disable root login
      lineinfile:
        path: /etc/ssh/sshd_config
        regexp: '^#?PermitRootLogin'
        line: 'PermitRootLogin no'
      notify: Restart SSH

    - name: Configure SSH - Disable password authentication
      lineinfile:
        path: /etc/ssh/sshd_config
        regexp: '^#?PasswordAuthentication'
        line: 'PasswordAuthentication no'
      notify: Restart SSH

    - name: Configure SSH - Allow only specific users
      lineinfile:
        path: /etc/ssh/sshd_config
        regexp: '^#?AllowUsers'
        line: "AllowUsers {{ allowed_ssh_users | join(' ') }}"
      notify: Restart SSH

    - name: Configure UFW defaults
      ufw:
        direction: "{{ item.direction }}"
        policy: "{{ item.policy }}"
      loop:
        - { direction: 'incoming', policy: 'deny' }
        - { direction: 'outgoing', policy: 'allow' }

    - name: Allow SSH through firewall
      ufw:
        rule: allow
        port: "{{ ssh_port }}"
        proto: tcp

    - name: Enable UFW
      ufw:
        state: enabled

    - name: Configure fail2ban
      copy:
        content: |
          [sshd]
          enabled = true
          port = {{ ssh_port }}
          filter = sshd
          logpath = /var/log/auth.log
          maxretry = 3
          bantime = 3600
        dest: /etc/fail2ban/jail.local
        owner: root
        group: root
        mode: '0644'
      notify: Restart fail2ban

    - name: Enable automatic security updates
      copy:
        content: |
          APT::Periodic::Update-Package-Lists "1";
          APT::Periodic::Download-Upgradeable-Packages "1";
          APT::Periodic::AutocleanInterval "7";
          APT::Periodic::Unattended-Upgrade "1";
        dest: /etc/apt/apt.conf.d/20auto-upgrades
        owner: root
        group: root
        mode: '0644'

    - name: Set secure file permissions
      file:
        path: "{{ item }}"
        mode: '0600'
      loop:
        - /etc/ssh/sshd_config
        - /etc/shadow
        - /etc/gshadow

  handlers:
    - name: Restart SSH
      systemd:
        name: sshd
        state: restarted

    - name: Restart fail2ban
      systemd:
        name: fail2ban
        state: restarted
```

## Monitoring Setup

### 7. Prometheus Node Exporter Playbook

```yaml
---
- name: Install Prometheus Node Exporter
  hosts: all
  become: yes
  vars:
    node_exporter_version: "1.7.0"
    node_exporter_port: 9100

  tasks:
    - name: Create node_exporter user
      user:
        name: node_exporter
        system: yes
        shell: /bin/false
        create_home: no

    - name: Download Node Exporter
      get_url:
        url: "https://github.com/prometheus/node_exporter/releases/download/v{{ node_exporter_version }}/node_exporter-{{ node_exporter_version }}.linux-amd64.tar.gz"
        dest: /tmp/node_exporter.tar.gz
        mode: '0644'

    - name: Extract Node Exporter
      unarchive:
        src: /tmp/node_exporter.tar.gz
        dest: /tmp
        remote_src: yes

    - name: Copy Node Exporter binary
      copy:
        src: "/tmp/node_exporter-{{ node_exporter_version }}.linux-amd64/node_exporter"
        dest: /usr/local/bin/node_exporter
        owner: node_exporter
        group: node_exporter
        mode: '0755'
        remote_src: yes

    - name: Create systemd service file
      copy:
        content: |
          [Unit]
          Description=Prometheus Node Exporter
          After=network.target

          [Service]
          Type=simple
          User=node_exporter
          Group=node_exporter
          ExecStart=/usr/local/bin/node_exporter
          Restart=always
          RestartSec=10

          [Install]
          WantedBy=multi-user.target
        dest: /etc/systemd/system/node_exporter.service
        owner: root
        group: root
        mode: '0644'
      notify:
        - Reload systemd
        - Restart node_exporter

    - name: Enable and start Node Exporter
      systemd:
        name: node_exporter
        enabled: yes
        state: started

    - name: Allow Node Exporter port through firewall
      ufw:
        rule: allow
        port: "{{ node_exporter_port }}"
        proto: tcp
        from_ip: "{{ prometheus_server_ip }}"
      when: prometheus_server_ip is defined

  handlers:
    - name: Reload systemd
      systemd:
        daemon_reload: yes

    - name: Restart node_exporter
      systemd:
        name: node_exporter
        state: restarted
```

## Inventory File Example

```ini
# inventory.ini

[webservers]
web1.example.com ansible_host=192.168.1.10
web2.example.com ansible_host=192.168.1.11

[appservers]
app1.example.com ansible_host=192.168.1.20
app2.example.com ansible_host=192.168.1.21

[dbservers]
db1.example.com ansible_host=192.168.1.30

[all:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=~/.ssh/id_rsa
ansible_python_interpreter=/usr/bin/python3
```

## Running Playbooks

```bash
# Run playbook
ansible-playbook -i inventory.ini playbook.yml

# Run with specific tags
ansible-playbook -i inventory.ini playbook.yml --tags "install,configure"

# Run in check mode (dry run)
ansible-playbook -i inventory.ini playbook.yml --check

# Run with verbose output
ansible-playbook -i inventory.ini playbook.yml -vvv

# Run on specific hosts
ansible-playbook -i inventory.ini playbook.yml --limit webservers

# Use vault for encrypted variables
ansible-playbook -i inventory.ini playbook.yml --ask-vault-pass
```

## Best Practices

1. **Use roles** for complex playbooks
2. **Implement idempotency** - playbooks should be safe to run multiple times
3. **Use variables** for configuration values
4. **Encrypt sensitive data** with Ansible Vault
5. **Test in staging** before production
6. **Use tags** for selective execution
7. **Document playbooks** with comments
8. **Version control** all playbooks
9. **Use handlers** for service restarts
10. **Implement error handling** with blocks and rescue

## Summary

These playbook examples cover common DevOps scenarios:
- System administration and updates
- Web server configuration
- Application deployment
- Database setup
- Security hardening
- Monitoring installation

Customize these examples for your specific infrastructure needs and always test in a non-production environment first.