#!/usr/bin/env bash

# Create a MySQL/MariaDB database and user.
# Usage: sudo ./create_db.sh db_name db_user db_password

set -euo pipefail

if [[ $EUID -ne 0 ]]; then
    echo "Please run this script as root or using sudo." >&2
    exit 1
fi

if [[ $# -ne 3 ]]; then
    echo "Usage: $0 <db_name> <db_user> <db_password>" >&2
    exit 1
fi

DB_NAME=$1
DB_USER=$2
DB_PASS=$3

echo "Creating database '$DB_NAME' and user '$DB_USER'…"

mysql -u root -p <<MYSQL
CREATE DATABASE IF NOT EXISTS \`$DB_NAME\`;
CREATE USER IF NOT EXISTS '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';
GRANT ALL PRIVILEGES ON \`$DB_NAME\`.* TO '$DB_USER'@'localhost';
FLUSH PRIVILEGES;
MYSQL

echo "Database and user created successfully."