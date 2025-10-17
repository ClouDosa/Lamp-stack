#!/usr/bin/env bash

# Simple script to install a LAMP stack on CentOS Stream 9.
# This script must be run as root or with sudo.

set -euo pipefail

echo "Updating system packages…"
dnf update -y

echo "Installing Apache (httpd)…"
dnf install -y httpd
systemctl start httpd
systemctl enable httpd

# Open firewall ports if firewalld is available
if systemctl is-active --quiet firewalld; then
    echo "Opening HTTP/HTTPS ports in firewalld…"
    firewall-cmd --permanent --add-service=http
    firewall-cmd --permanent --add-service=https
    firewall-cmd --reload
fi

echo "Installing MariaDB server…"
dnf install -y mariadb-server
systemctl start mariadb
systemctl enable mariadb

echo "Securing MariaDB installation…"
echo "You will be prompted to set a root password and remove test databases."
mysql_secure_installation

echo "Installing PHP and extensions…"
dnf install -y php php-cli php-common php-gd php-mysqlnd php-pdo php-mbstring php-opcache php-xml

echo "Restarting Apache to load PHP module…"
systemctl restart httpd

echo "LAMP installation complete. You can deploy your web application to /var/www/html."