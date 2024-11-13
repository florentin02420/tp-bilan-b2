#!/bin/bash

# Créer un répertoire pour le projet WordPress
mkdir -p ~/wordpress

# Se rendre dans le répertoire du projet
cd ~/wordpress

# Créer le fichier docker-compose.yml
cat << EOF > docker-compose.yml
version: '3.7'

services:
  wordpress:
    image: wordpress:latest
    container_name: wordpress
    ports:
      - "8081:80"
    environment:
      WORDPRESS_DB_HOST: db:3306
      WORDPRESS_DB_NAME: wordpress
      WORDPRESS_DB_USER: root
      WORDPRESS_DB_PASSWORD: example
    volumes:
      - wordpress_data:/var/www/html
    restart: always
    depends_on:
      - db

  db:
    image: mysql:5.7
    container_name: db
    environment:
      MYSQL_ROOT_PASSWORD: example
    volumes:
      - db_data:/var/lib/mysql
    restart: always

volumes:
  wordpress_data:
  db_data:
EOF

# Lancer Docker Compose pour démarrer WordPress et MySQL
echo "Lancement de WordPress et MySQL avec Docker Compose..."
docker compose up -d

echo "WordPress est maintenant accessible sur http://localhost:8081"
