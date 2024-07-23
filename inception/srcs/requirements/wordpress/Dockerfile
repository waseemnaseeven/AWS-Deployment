# Utilisation de l'image de base Debian Buster
FROM debian:buster

# Mise à jour et installation des paquets nécessaires
RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install -y wget
RUN apt-get install -y php7.3 php-fpm php-mysql

# Installation de WP-CLI (l'interface de ligne de commande de WordPress)
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Installation des clients MySQL et MariaDB
RUN apt-get update && apt-get install -y default-mysql-client
RUN apt-get install -y mariadb-client

# Téléchargement et extraction de WordPress
RUN wget https://wordpress.org/wordpress-6.1.1.tar.gz -P /var/www/html \
    && cd /var/www/html \
    && tar -xzf /var/www/html/wordpress-6.1.1.tar.gz \
    && rm /var/www/html/wordpress-6.1.1.tar.gz

# Attribution des droits appropriés au répertoire WordPress
RUN chown -R www-data:www-data /var/www/html/wordpress/
RUN chmod -R 755 /var/www/*

# Copie du script d'initialisation WordPress
COPY ./tools/wpscript.sh ./
RUN chmod +x wpscript.sh

# Copie du fichier de configuration PHP-FPM www.conf
COPY ./tools/www.conf /etc/php/7.3/fpm/pool.d/www.conf

# Point d'entrée pour le conteneur, exécute le script d'initialisation WordPress
ENTRYPOINT ["bash", "./wpscript.sh"]
