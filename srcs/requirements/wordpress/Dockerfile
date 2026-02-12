FROM debian:stable-slim

# Environment variables
# ENV WP_DB_NAME=placeholder_db
# ENV WP_DB_USER=wp_user
# ENV WP_DB_HOST=mariadb

# Install PHP and required extensions
RUN apt-get update \
    && apt-get install -y \
        php-fpm php-mysql php-cli php-mbstring php-xml php-curl wget unzip \
    && rm -rf /var/lib/apt/lists/*

# Make PHP-FPM listen on port 9000
RUN sed -i 's|listen = .*|listen = 9000|' /etc/php/*/fpm/pool.d/www.conf

# Download WordPress
WORKDIR /var/www/
RUN wget https://wordpress.org/latest.zip -O wordpress.zip \
    && unzip wordpress.zip \
    && rm wordpress.zip \
    && chown -R www-data:www-data wordpress

# Copy entrypoint
COPY tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expose php-fpm port
EXPOSE 9000

# Start entrypoint
ENTRYPOINT ["/entrypoint.sh"]
