#!/bin/sh
set -e

# Default API host if not provided
: ${API_HOST:=forum-api:3000}

if [ -f /etc/nginx/conf.d/default.conf.template ]; then
  echo "Substituting /etc/nginx/conf.d/default.conf.template -> /etc/nginx/conf.d/default.conf"
  envsubst '${API_HOST}' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf
  # Remove possible Windows CRLF endings that break nginx (invalid port due to \r)
  sed -i 's/\r$//' /etc/nginx/conf.d/default.conf || true
  echo "API_HOST=${API_HOST}"
fi

exec nginx -g 'daemon off;'
