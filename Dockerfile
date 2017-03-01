FROM debian:jessie

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -qq && \
    apt-get install -y proftpd proftpd-mod-mysql && \
    apt-get clean autoclean && \
    apt-get autoremove --yes && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/

RUN	sed -i.bak "s/# DefaultRoot/DefaultRoot/" /etc/proftpd/proftpd.conf
RUN echo "Include /etc/proftpd/sql.conf" >> /etc/proftpd/proftpd.conf
RUN echo "RequireValidShell off" >> /etc/proftpd/proftpd.conf

RUN echo "LoadModule mod_sql.c" >> /etc/proftpd/modules.conf
RUN echo "LoadModule mod_sql_mysql.c" >> /etc/proftpd/modules.conf

ADD sql.conf /etc/proftpd/sql.conf

EXPOSE 20 21

ADD	entrypoint.sh /usr/local/sbin/entrypoint.sh
RUN chmod +x /usr/local/sbin/entrypoint.sh
ENTRYPOINT ["/usr/local/sbin/entrypoint.sh"]

CMD	["proftpd", "--nodaemon"]
