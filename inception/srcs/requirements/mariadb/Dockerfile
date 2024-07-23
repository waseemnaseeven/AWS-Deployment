FROM debian:buster

# Install packages
RUN apt-get update && apt-get upgrade -y 
    
RUN apt-get install -y \
    mariadb-server \
    mariadb-client \
    procps

COPY ./conf/50-server.cnf	/etc/mysql/mariadb.conf.d/50-server.cnf

RUN mkdir -p /var/run/mysqld
RUN mkdir -p /var/lib/mysql
RUN chown mysql:mysql /var/run/mysqld/
RUN chmod -R 755 /var/run/mysqld/
RUN chown mysql:mysql /var/lib/mysql/
RUN chmod -R 755 /var/lib/mysql/

COPY ./tools/MySQL.sh ./
RUN chmod +x ./MySQL.sh

ENTRYPOINT [ "bash", "./MySQL.sh" ]
