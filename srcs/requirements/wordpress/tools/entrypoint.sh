#!/bin/sh
set -e #Exit immediately if a command exits with a non-zero status.

WP_DB_PASSWORD=$(cat /run/secrets/db_password)
WP_DB_USER=$MYSQL_USER

echo "Starting PHP-FPM..."
exec /usr/sbin/php-fpm8.4 -F

