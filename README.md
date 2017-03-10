# ProFTPD-MySQL

ProFTPD Base Image including MySQL database authentication support.

## DockerHub

This is available on [DockerHub](https://hub.docker.com/r/cyberduck/proftpd-mysql) under the `cyberduck/proftpd-mysql` image name.

## Usage

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
            - "60000-60100:60000-60100"
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
            PROFTPD_USER: proftpd
            WEB_GROUP: www-data
        volumes:
            - /path/to/ftp/folder:/path/to/ftp/folder
        networks:
            - some_network_name
        ports:
            - "21:21"
            - "20:20"
            - "60000-60100:60000-60100"
```

## MySQL Tables to generate

```sql
CREATE TABLE IF NOT EXISTS `ftp_groups` (
    `group_name` varchar(16) COLLATE utf8_general_ci NOT NULL,
    `gid` smallint(6) NOT NULL DEFAULT '5500',
    `members` varchar(16) COLLATE utf8_general_ci NOT NULL,
    KEY `group_name` (`group_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
```

```sql
CREATE TABLE IF NOT EXISTS `ftp_users` (
    `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
    `user_name` varchar(32) COLLATE utf8_general_ci NOT NULL DEFAULT '',
    `password` varchar(32) COLLATE utf8_general_ci NOT NULL DEFAULT '',
    `uid` smallint(6) NOT NULL DEFAULT '5500',
    `gid` smallint(6) NOT NULL DEFAULT '5500',
    `home_directory` varchar(255) COLLATE utf8_general_ci NOT NULL DEFAULT '',
    `shell` varchar(16) COLLATE utf8_general_ci NOT NULL DEFAULT '/sbin/nologin',
    `count` int(11) NOT NULL DEFAULT '0',
    `accessed_at` timestamp NULL,
    `modified_at` timestamp NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `userid` (`user_name`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
```

## Password generation

This image supports both `OpenSSL` and `Crypt` for password encryption.

`Crypt` is the one used when the MySQL function `PASSWORD()` is used.

To generate a password for `OpenSSL` please use the following:

`echo -n "your_password" | openssl dgst -binary -md5 | openssl enc -base64`

# User and Group customization

If you would like to change the user and group the ProFTPD service/server is running as,
you can use the following environment variables :

* `PROFTPD_USER` (default is set to `nobody`)
* `WEB_GROUP` (default is set to `nobody`)

## Test it

You can use your favourite FTP client (such as FileZilla) to connect to the server with the sample user you added before.

You can also run `ftp localhost` from your macOS host machine for example.

## Troubleshooting

You can view the log files of ProFTPD itself:

`tail -f /var/log/proftpd/proftpd.log`

And the SQL part of ProFTPD:

`tail -f /var/log/proftpd/sql.log`
