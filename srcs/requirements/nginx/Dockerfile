FROM debian:stable-slim

RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    && rm -rf /var/lib/apt/lists/*

# Remove default config
RUN rm -f /etc/nginx/sites-enabled/default

COPY conf/default.conf /etc/nginx/conf.d/default.conf
COPY tools/generate_ssl.sh /generate_ssl.sh

RUN chmod +x /generate_ssl.sh

EXPOSE 443

ENTRYPOINT ["/generate_ssl.sh"]
