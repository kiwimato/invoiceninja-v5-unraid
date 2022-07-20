# Invoice Ninja v5 UnRAID Docker image
This is just a wrapper over the original Docker image created by [Invoice Ninja](https://www.invoiceninja.com/) so it works in UnRAID.

## Releases
The docker image is built every night at 01:00 UTC, so any Invoice Ninja version released before that time should be built inside the image.

## Installation
This image requires MariaDB or MySQL database running in a different container. 

Prior to installing the container, please create a new DB for it in MariaDB/MySQL by running:
```
CREATE DATABASE invoiceninja5;
```
Of course, if you already have a SQL user you can use that or create one specifically for Invoiceninja and use that.

:warning: Trusted SSL certificates are a must for this to work properly, so if you using SWAG you can just copy the certificates from SWAG into `storage/certificates` and replace the existing ones. 
On the first run, self-signed certificates are automatically generated under this folder if they don't already exist. 
You can either replace them with SWAG ones, or import the self signed certificates into your preferred browser. More in [SSL certificates](#SSL)

:warning: `APP_NAME` variable MUST be set properly on the first run. If you have to change it for some reason, you will have to DROP the DB and recreate everything, so please make sure to set it up properly from start. 
It must be a URL, for example: `https://superninja.com:8443`. 
The automated self signed certificates are generated on this FQDN, but of course SWAG certificate must also match this, otherwise SSL errors will break the UI even if you ignore the certificate error.

## SSL
I found disabling HTTPS to be quite buggy, so there is a script which will auto generate SSL certificates in `certs/` folder in Storage: `/mnt/user/appdata/invoiceninjav5/storage/certs` on UnRAID level.

A certificate will be created with the `CN` = `$SSL_HOSTNAME` env variable, which has the default value of `Tower`: `invoiceninja.crt` and `invoiceninja.key`. 
To properly use InvoiceNinja you'll have to import the certificate in your browser as a CA, otherwise I found requests to fail.

I strongly recommend using LetsEncrypt or SWAG on UnRAID and then you can simply create/overwrite `invoiceninja.crt` with `fullchain.pem` and also the same thing for the key, of course.
Note: `APP_URL` env variable should be the form of `https://domain.com[:port]`. For example: `https://supercool.com:8443`


## Upgrade from v4 to v5
If you already have Invoice Ninja v4 on UnRAID:
   * Run this image on a whole new database while providing credentials `IN_USER_EMAIL` and `IN_PASSWORD` which match the v4 one. 
     This is a requirement for the migration tool to work.
   * Use [this how to](https://invoiceninja.github.io/docs/migration/)
     Note: Since the certificate over HTTPS is self signed, you'll have to migrate over HTTP, or import the certs in the v4 container, if you're not using proper certificates, of course.
     Otherwise, the migration will fail with `Whoops, looks like something went wrong.`
   
## Troubleshooting

### memory_limit
In case the container dies due to memory_limit errors similar to:
```
PHP Fatal error: Allowed memory size of 268435456 bytes exhausted
```
You can override the memory limit by passing an environment variable called MEMORY_LIMIT.
Example:
```
MEMORY_LIMIT=512M
```


## Issues
Feel free to raise PRs or create issues [here](https://github.com/kiwimato/invoiceninja-v5-unraid/issues)
