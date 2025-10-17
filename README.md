# LAMP Stack Setup on CentOS Stream 9

# Overview

This repository contains a complete, working example of how to configure a **LAMP** (Linux, Apache, MySQL/MariaDB and PHP) stack on **CentOS Stream 9**.  The goal is to provide a reproducible reference project you can check out, follow along with, and adapt for your own web‑application deployments.  All of the files live in a single Git tree, making it easy to version control your infrastructure as code.

The installation instructions in this project are based on up‑to‑date CentOS 9 documentation.  For example, the `dnf` package manager is used to install Apache (`httpd`), MariaDB (a drop‑in MySQL replacement) and PHP packages【480713083918559†L53-L67】【480713083918559†L72-L84】.  After installing each package, the services are started and enabled so that they automatically launch at boot time.  The project also includes a simple PHP information script for testing the stack【480713083918559†L116-L135】.

## Project Structure

```
lamp-project/
├── ansible/
│   ├── inventory           # Inventory file for Ansible (defaults to localhost)
│   ├── playbook.yml        # Top‑level playbook that calls component roles
│   └── roles/
│       ├── apache/
│       │   └── tasks/main.yml   # Install and configure Apache
│       ├── mariadb/
│       │   └── tasks/main.yml   # Install and secure MariaDB
│       └── php/
│           └── tasks/main.yml   # Install PHP and extensions
├── scripts/
│   ├── install_lamp.sh     # Bash script to install LAMP components manually
│   ├── create_db.sh        # Example script to create a database and user
│   └── test_site.sh        # Deploy a sample PHP page for verification
├── sample_site/
│   ├── index.php           # Sample application (hello world + DB test)
│   └── phpinfo.php         # PHP info file to confirm PHP is working
└── README.md               # Documentation (this file)
```

### Ansible Roles

The project uses a simple Ansible playbook to automate the installation and configuration steps.  Roles are self‑contained directories under `ansible/roles/`.  Each role installs a single component and enables its service:

- **apache** – Installs the `httpd` package with `dnf`, opens HTTP/HTTPS firewall ports with `firewalld`, starts the service and enables it on boot【99786774743717†L42-L60】.
- **mariadb** – Installs `mariadb-server` and runs the `mysql_secure_installation` script to set a root password and remove test databases【99786774743717†L72-L91】.
- **php** – Installs PHP (`php`, `php-cli`) and common extensions (`php-gd`, `php-mysqlnd`, `php-pdo`, etc.)【480713083918559†L88-L95】.  After installation, the Apache service is restarted so that the new PHP module is loaded【99786774743717†L122-L124】.

### Scripts

If you do not want to use Ansible, the `scripts/` directory contains plain‑bash scripts that perform the same tasks.  Running `install_lamp.sh` as root will update your system, install Apache, MariaDB and PHP packages with `dnf`, start the services, and optionally open firewall ports.  The `create_db.sh` script demonstrates how to create a database and grant privileges to a new user, and `test_site.sh` copies a simple PHP page into `/var/www/html`.

### Sample Application

The `sample_site/` directory holds two example PHP files:

- `phpinfo.php` – this file calls `phpinfo()` to display your server's PHP configuration.  Visiting it in a browser confirms that Apache and PHP are working together【480713083918559†L116-L135】.
- `index.php` – a minimal application that displays a greeting and attempts a database connection using PDO.  Use it as a starting point for your own applications.

## Quick Start

These instructions assume you have a freshly installed CentOS Stream 9 server with sudo privileges and an internet connection.

### Running via Ansible (recommended)

1. Install Ansible on your local machine or on the server.  On CentOS 9 the package is available in the default repository:

   ```bash
   sudo dnf install ansible -y
   ```

2. Clone this repository and change into the project directory:

   ```bash
   git clone https://github.com/yourusername/lamp-project.git
   cd lamp-project/ansible
   ```

3. Review and edit `ansible/inventory` if you plan to target remote hosts.  By default, it contains `localhost`.

4. Run the playbook with elevated privileges:

   ```bash
   ansible-playbook -i inventory playbook.yml -b
   ```

   The `-b` flag tells Ansible to become (sudo) root for tasks that require elevated privileges.  The playbook will install and configure Apache, MariaDB and PHP, open firewall ports, and deploy the `phpinfo.php` file.

5. Visit `http://<your-server-ip>/phpinfo.php` in a browser.  You should see the PHP information page, confirming that the stack is operational【480713083918559†L116-L135】.

### Running via Bash scripts

1. SSH into your CentOS 9 server as a user with sudo privileges.

2. Update your system and install the packages manually by running the script:

   ```bash
   sudo bash scripts/install_lamp.sh
   ```

   This script performs the following steps:
   - Updates the package index (`dnf update`).
   - Installs `httpd` and starts/enables the Apache service【480713083918559†L53-L67】.
   - Installs `mariadb-server` and starts/enables it【480713083918559†L72-L84】.
   - Runs `mysql_secure_installation` to set a root password and remove test databases【480713083918559†L84-L87】.
   - Installs PHP and common extensions【480713083918559†L88-L95】.
   - Restarts Apache to load the PHP module【99786774743717†L122-L124】.
   - Opens HTTP/HTTPS ports in the firewall if `firewalld` is present.【99786774743717†L62-L66】

3. (Optional) Create a database and user by running:

   ```bash
   sudo bash scripts/create_db.sh myappdb myuser mypassword
   ```

   Replace `myappdb`, `myuser` and `mypassword` with your desired database name, username and strong password.

4. Deploy the sample site:

   ```bash
   sudo bash scripts/test_site.sh
   ```

   This copies `sample_site/phpinfo.php` and `sample_site/index.php` into `/var/www/html/` so they can be accessed via Apache.

5. Open a browser to `http://<your-server-ip>/index.php`.  You should see a greeting and a database connection status.  If everything is set up correctly, the page will report a successful connection to your new database.

## Sample Database Connection (index.php)

Here is the simplified logic from `sample_site/index.php`.  It connects to MariaDB via PDO and displays a message on success or failure:

```php
<?php
$dsn = 'mysql:host=localhost;dbname=${DB_NAME}';
$user = '${DB_USER}';
$password = '${DB_PASS}';

try {
    $pdo = new PDO($dsn, $user, $password);
    echo 'Connected to the database successfully.';
} catch (PDOException $e) {
    echo 'Connection failed: ' . htmlspecialchars($e->getMessage());
}
?>
```

Before deploying your own applications, edit the database credentials and any other configuration values in `sample_site/index.php`.

## Why Use This Project?

- **Repeatability:** All commands and scripts are version controlled, so you always know what packages and versions were installed.
- **Automation:** Use Ansible or the provided shell scripts to automate repetitive installation tasks.  This reduces human error and ensures consistent builds across servers.
- **Documentation:** The repository explains not only **how** to install each component but also **why**.  For example, opening the firewall for HTTP/HTTPS traffic is necessary for remote access【99786774743717†L62-L66】.
- **Extensibility:** You can extend the playbook or scripts to add virtual hosts, SSL certificates, phpMyAdmin, or other services like memcached and Redis.

## Troubleshooting

- If Apache fails to start, check the status with `sudo systemctl status httpd` and review `/var/log/httpd/error_log`.
- If you cannot connect to MariaDB, ensure the service is running (`sudo systemctl status mariadb`) and that you can log in with `mysql -u root -p`.
- For PHP errors, enable error reporting in your `php.ini` or inspect Apache’s error log.

## Contributing

Feel free to submit issues or pull requests.  If you find a better way to automate or secure this stack, contributions are welcome.  Make sure your changes align with CentOS Stream 9 best practices and include updates to this documentation.
