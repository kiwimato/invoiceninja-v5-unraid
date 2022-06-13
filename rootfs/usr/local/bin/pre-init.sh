#!/bin/sh
# Create a link to .env file so that APP_KEY is persistent across container updates
# To update it, simply remove the file and it will be regenerate on next boot
if [[ ! -f /var/www/app/storage/.env ]]; then
  touch /var/www/app/storage/.env

  if [[ "$(cat /var/www/app/storage/.env | grep APP_KEY)" == "" ]];then
    echo APP_KEY missing from storage/.env, generating APP_KEY
    echo "APP_KEY=$(php artisan key:generate --show)" >>/var/www/app/storage/.env
  fi
fi

if [[ $MEMORY_LIMIT ]]; then
  echo "Updating php.ini with memory_limit = $MEMORY_LIMIT"
  sed -i -e "s/memory_limit = 256M/memory_limit = $MEMORY_LIMIT/g" /usr/local/etc/php/php.ini
fi

export "$(grep APP_KEY /var/www/app/storage/.env)"

php artisan config:cache

/usr/local/bin/genssl.sh

find /var/www/app \
     -not -path '/var/www/app/vendor/*' \
     -exec chown -v www-data:www-data {} +

exec "$@"
