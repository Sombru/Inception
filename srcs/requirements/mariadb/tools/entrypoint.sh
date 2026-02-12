#!/bin/sh
set -e

# Get secrets
MYSQL_PASSWORD=$(cat /run/secrets/db_password)
MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld
chown -R mysql:mysql /var/lib/mysql

# Initialize database if empty
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB data directory..."
    mysql_install_db --user=mysql --ldata=/var/lib/mysql
fi

echo "Starting MariaDB with skip-grant-tables..."
mysqld --user=mysql --skip-networking --skip-grant-tables &
pid="$!"

# Wait until server is ready
until mysqladmin ping --silent; do
    sleep 1
done

echo "Configuring database..."

mysql << EOF
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

# Stop temporary server
kill "$pid"
wait "$pid"

echo "Starting MariaDB normally..."
exec mysqld --user=mysql --bind-address=0.0.0.0
