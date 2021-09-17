# Invoice Ninja v5 UnRAID Docker image
This is just a wrapper over the original Docker image created by [Invoice Ninja](https://www.invoiceninja.com/) so it works in UnRAID.

## Releases
The docker image is built every night at 01:00 UTC, so any Invoice Ninja version released before that time should be built inside the image.

## SSL certificates
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
