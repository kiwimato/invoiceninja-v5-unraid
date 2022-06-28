#!/bin/sh
SSL_HOSTNAME=${SSL_HOSTNAME:-tower}
for HOSTNAME in `echo $SSL_HOSTNAME | tr ',' '\n'`;do
  ALT_DNS_OPT+=" -addext \"subjectAltName = DNS:${HOSTNAME}\""
done


DIR="/etc/nginx/ssl/"
STORAGE="/var/www/app/storage/certs"

[[ ! -d "$DIR" ]] && mkdir -p $DIR
[[ ! -d "$STORAGE" ]] && mkdir -p $STORAGE


if [[ -f "$STORAGE/invoiceninja.crt" ]] && [[ -f "$STORAGE/invoiceninja.key" ]];then
  if [[ -f "$DIR/invoiceninja.crt" ]] && [[ -f "$DIR/invoiceninja.key" ]] ;then
    echo "Cert already generated & linked"
    exit
  else
    echo "Creating link for certificates"
    ln -s "$STORAGE/invoiceninja.crt" "$DIR/invoiceninja.crt"
    ln -s "$STORAGE/invoiceninja.key" "$DIR/invoiceninja.key"
    exit
  fi
fi

# Generate our key
openssl genrsa 4096 > $STORAGE/invoiceninja.key

# Create the self-signed certificate for all invoiceninja
openssl req -new \
            -x509 \
            -nodes \
            -sha256 \
            -days 3650 \
            $ALT_DNS_OPT \
            -key $STORAGE/invoiceninja.key \
            << ANSWERS > $STORAGE/invoiceninja.crt
JP
NinjaTown
NinjaCity
invoiceninja
Me
$SSL_HOSTNAME
admin@localhost
ANSWERS

ln -s "$STORAGE/invoiceninja.crt" "$DIR/invoiceninja.crt"
ln -s "$STORAGE/invoiceninja.key" "$DIR/invoiceninja.key"
