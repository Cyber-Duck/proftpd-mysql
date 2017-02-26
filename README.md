# ProFTPD-MySQL

ProFTPD Base Image including MySQL database authentication support.

Example of running the image for one single standard FTP user using `docker-compose`:

```yaml
version: '2'
services:
    ftp:
        image: cyberduck/proftpd-mysql
        environment:
            FTP_USERNAME: ftp_user_name
            FTP_PASSWORD: ftp_user_password
        volumes:
            - /path/to/ftp/folder:/home/ftp_user_name
        networks:
            - some_network_name
        ports:
            - "21:21"
            - "20:20"
```

Example of running the image for a MySQL database authentication using `docker-compose`:

```yaml
version: '2'
services:
    ftp:
        image: cyberduck/proftpd-mysql
        environment:
            MYSQL_HOST: mysql_host_address
            MYSQL_DATABASE: mysql_database_name
            MYSQL_USER: mysql_username
            MYSQL_PASSWORD: mysql_password
        volumes:
            - /path/to/ftp/folder:/path/to/ftp/folder
        networks:
            - some_network_name
        ports:
            - "21:21"
            - "20:20"
```

## Password generation

This image supports both `OpenSSL` and `Crypt` for password encryption.

`Crypt` is the one used when the MySQL function `PASSWORD()` is used.

To generate a password for `OpenSSL` please use the following:

`echo -n "your_password" | openssl dgst -binary -md5 | openssl enc -base64`

## Test it

You can use your favourite FTP client (such as FileZilla) to connect to the server with the sample user you added before.

## Troubleshooting

You can view the log files of ProFTPD itself:

`tail -f /var/log/proftpd/proftpd.log`

And the SQL part of ProFTPD:

`tail -f /var/log/proftpd/sql.log`
