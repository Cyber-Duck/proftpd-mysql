#!/bin/sh

if [ -n "$FTP_USERNAME" -a -n "$FTP_PASSWORD" ]; then
	CRYPTED_PASSWORD=$(perl -e 'print crypt($ARGV[0], "password")' $FTP_PASSWORD)
	mkdir /home/$FTP_USERNAME
	useradd --shell /bin/sh -d /home/$FTP_USERNAME --password $CRYPTED_PASSWORD $FTP_USERNAME
	chown -R $FTP_USERNAME:$FTP_USERNAME /home/$FTP_USERNAME
fi

if [ -n "$MYSQL_HOST" -a -n "$MYSQL_DATABASE" -a -n "$MYSQL_USER" -a -n "$MYSQL_PASSWORD" ]; then
	echo "\n\nSQLConnectInfo $MYSQL_DATABASE@$MYSQL_HOST $MYSQL_USER $MYSQL_PASSWORD" >> /etc/proftpd/sql.conf
fi

if [ -n "$PROFTPD_USER" -a -n "$WEB_GROUP" ]; then
	sed -i.bak "s/^\(User\).*/User $PROFTPD_USER/" /etc/proftpd/proftpd.conf
	sed -i.bak "s/^\(Group\).*/Group $WEB_GROUP/" /etc/proftpd/proftpd.conf
fi

exec "$@"
