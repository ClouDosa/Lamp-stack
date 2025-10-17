<?php
/**
 * Example PHP page that connects to a MySQL/MariaDB database using PDO
 * and displays a simple message.  Replace the placeholders for
 * database name, username and password with your own credentials.
 */

$dsn = 'mysql:host=localhost;dbname=CHANGE_ME_DB;charset=utf8mb4';
$dbUser = 'CHANGE_ME_USER';
$dbPass = 'CHANGE_ME_PASS';

echo "<h1>Hello from LAMP on CentOS 9!</h1>";

try {
    $pdo = new PDO($dsn, $dbUser, $dbPass, [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    ]);
    echo '<p>Connected to the database successfully.</p>';
} catch (PDOException $e) {
    echo '<p style="color:red">Database connection failed: ' . htmlspecialchars($e->getMessage()) . '</p>';
}

?>