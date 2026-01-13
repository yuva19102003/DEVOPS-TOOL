#!/bin/bash

# ------------------------------------------------------
# Production Server Bootstrap Script (Version Controlled)
# ------------------------------------------------------

set -e

GREEN="\e[32m"
RED="\e[31m"
NC="\e[0m"

log() { echo -e "${GREEN}▶ $1${NC}"; }
error() { echo -e "${RED}✖ $1${NC}"; }

# ----------- Versions -------------
NODE_VERSION="lts"
GO_VERSION="1.22.1"

# ---------- Base Tools ----------
install_base_tools() {
  log "Installing Curl, Wget, Build Tools..."
  apt-get install -y curl wget unzip build-essential software-properties-common
}

install_git() {
  log "Installing Git..."
  apt-get install -y git
}

# ---------- Golang ----------
install_golang() {
  log "Installing Golang v$GO_VERSION..."

  cd /tmp
  wget https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz

  rm -rf /usr/local/go
  tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz

  echo 'export PATH=$PATH:/usr/local/go/bin' > /etc/profile.d/go.sh
  source /etc/profile.d/go.sh

  go version
  log "Golang installed"
}

# ---------- Node + PM2 ----------
install_node_pm2() {
  log "Installing Node.js ($NODE_VERSION)..."
  curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash -
  apt-get install -y nodejs
  npm install -g pm2
  pm2 startup systemd -u $SUDO_USER --hp /home/$SUDO_USER
}

# ---------- Firewall + Security ----------
install_ufw_fail2ban() {
  log "Installing UFW and Fail2ban..."
  apt-get install -y ufw fail2ban
  ufw allow OpenSSH
  ufw allow 80
  ufw allow 443
  ufw --force enable
  systemctl enable fail2ban
  systemctl start fail2ban
}

install_auto_updates() {
  log "Installing Auto Security Updates..."
  apt-get install -y unattended-upgrades
  dpkg-reconfigure --priority=low unattended-upgrades
}

# ---------- Nginx + Certbot ----------
install_nginx() {
  log "Installing Nginx..."
  apt-get install -y nginx
  systemctl enable nginx
  systemctl start nginx
}

install_certbot() {
  log "Installing Certbot..."
  apt-get install -y certbot python3-certbot-nginx
  echo "Run: sudo certbot --nginx -d yourdomain.com"
}

# ---------- Docker ----------
install_docker() {
  log "Installing Docker..."
  apt-get install -y ca-certificates gnupg lsb-release
  mkdir -p /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
    gpg --dearmor -o /etc/apt/keyrings/docker.gpg

  echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
  > /etc/apt/sources.list.d/docker.list

  apt-get update
  apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
  systemctl enable docker
  systemctl start docker
}

# ---------- Logrotate ----------
install_logrotate() {
  log "Installing Logrotate..."
  apt-get install -y logrotate
  systemctl enable logrotate.timer
}

# ---------- Swap ----------
install_swap() {
  log "Creating 2GB swap..."
  fallocate -l 2G /swapfile
  chmod 600 /swapfile
  mkswap /swapfile
  swapon /swapfile
  echo '/swapfile none swap sw 0 0' >> /etc/fstab
}

# ---------- Install All ----------
install_all() {
  install_base_tools
  install_git
  install_golang
  install_node_pm2
  install_ufw_fail2ban
  install_auto_updates
  install_nginx
  install_certbot
  install_docker
  install_logrotate
  install_swap
}

# ---------- Menu ----------
show_menu() {
echo ""
echo "====== Production Server Setup ======"
echo "1) Base Tools"
echo "2) Git"
echo "3) Golang ($GO_VERSION)"
echo "4) Node.js + PM2 ($NODE_VERSION)"
echo "5) UFW + Fail2ban"
echo "6) Auto Security Updates"
echo "7) Nginx"
echo "8) Certbot"
echo "9) Docker"
echo "10) Logrotate"
echo "11) Swap"
echo "12) Install EVERYTHING"
echo "13) Exit"
echo "====================================="
}

# ---------- Root Check ----------
if [[ $EUID -ne 0 ]]; then
  error "Run: sudo ./server-setup.sh"
  exit 1
fi

apt-get update -y

# ---------- Main ----------
while true; do
  show_menu
  read -p "Select option: " choice
  case $choice in
    1) install_base_tools ;;
    2) install_git ;;
    3) install_golang ;;
    4) install_node_pm2 ;;
    5) install_ufw_fail2ban ;;
    6) install_auto_updates ;;
    7) install_nginx ;;
    8) install_certbot ;;
    9) install_docker ;;
    10) install_logrotate ;;
    11) install_swap ;;
    12) install_all ;;
    13) log "Done"; exit 0 ;;
    *) error "Invalid option" ;;
  esac
done
