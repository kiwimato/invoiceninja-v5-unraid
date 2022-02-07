FROM invoiceninja/invoiceninja:5
USER root

COPY rootfs /

RUN apk update && \
    apk add nginx \
            tzdata && \
    mkdir -p /run/nginx /var/www/app/public /var/www/app/public/storage/backups && \
    chown -R www-data:www-data /var/lib/nginx/tmp /var/lib/nginx /var/www/app/ && \
    rm -rf /var/www/app/.env && \
    sed -i -e 's/memory_limit = 128M/memory_limit = 256M/g' /usr/local/etc/php/php.ini

EXPOSE 80

CMD ["/usr/local/bin/pre-init.sh", "supervisord"]
