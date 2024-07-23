#!/bin/bash

# Déplace le répertoire de travail vers le répertoire WordPress
cd /var/www/html/wordpress

# Vérifie si WordPress est déjà installé
if ! wp core is-installed; then
    # Crée le fichier de configuration de WordPress
    wp config create --allow-root --dbname=${SQL_DATABASE} \
        --dbuser=${SQL_USER} \
        --dbpass=${SQL_PASSWORD} \
        --dbhost=${SQL_HOST} \
        --url=https://${DOMAIN_NAME};

    # Install WordPress
    wp core install --allow-root \
        --url=https://${DOMAIN_NAME} \
        --title=${SITE_TITLE} \
        --admin_user=${ADMIN_USER} \
        --admin_password=${ADMIN_PASSWORD} \
        --admin_email=${ADMIN_EMAIL};

    # Crée un utilisateur supplémentaire avec le rôle d'auteur
    wp user create --allow-root \
        ${USER1_LOGIN} ${USER1_MAIL} \
        --role=author \
        --user_pass=${USER1_PASS};

    # Rafraîchit le cache WordPress
    wp cache flush --allow-root

    # Installe le plugin de formulaire de contact Contact Form 7
    wp plugin install contact-form-7 --activate

    # Définit la langue du site en anglais
    wp language core install en_US --activate

    # Supprime les thèmes et plugins par défaut
    wp theme delete twentynineteen twentytwenty
    wp plugin delete hello

    # Définit la structure des permaliens
    wp rewrite structure '/%postname%/'
fi

# Vérifie si le répertoire /run/php existe, sinon le crée
if [ ! -d /run/php ]; then
    mkdir /run/php;
fi

# Démarre le gestionnaire de processus PHP FastCGI (FPM) pour la version PHP 7.3 en avant-plan
exec /usr/sbin/php-fpm7.3 -F -R
