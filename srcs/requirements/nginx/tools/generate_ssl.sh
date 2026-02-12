#!/bin/bash
set -e

# Generate self-signed certificate
openssl req -x509 -nodes -days 365 \
  -newkey rsa:2048 \
  -keyout /etc/ssl/private/nginx.key \
  -out /etc/ssl/certs/nginx.crt \
  -subj "/C=CZ/ST=Prague/L=Prague/O=42/OU=42/CN=${DOMAIN_NAME}"

# Start nginx as main procces (PID 1)
exec nginx -g "daemon off;"
