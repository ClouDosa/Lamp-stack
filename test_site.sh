#!/usr/bin/env bash

# Deploy the sample PHP files to the web root on CentOS Stream 9.
# Requires root privileges to write into /var/www/html.

set -euo pipefail

if [[ $EUID -ne 0 ]]; then
    echo "Please run this script as root or using sudo." >&2
    exit 1
fi

PROJECT_DIR=$(dirname "$(realpath "$0")")/..
WEB_ROOT="/var/www/html"

echo "Copying sample site files into ${WEB_ROOT}…"

cp -v "$PROJECT_DIR/sample_site/phpinfo.php" "$WEB_ROOT/phpinfo.php"
cp -v "$PROJECT_DIR/sample_site/index.php" "$WEB_ROOT/index.php"

chown apache:apache "$WEB_ROOT/phpinfo.php" "$WEB_ROOT/index.php" || true

echo "Sample site deployed. Visit http://<server-ip>/phpinfo.php or /index.php to test."