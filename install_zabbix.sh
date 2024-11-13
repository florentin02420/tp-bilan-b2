#!/bin/bash

# Script pour installer Zabbix avec Docker Compose (sans Docker et Docker Compose)

# Assurez-vous que le script est exécuté en tant qu'utilisateur root ou avec sudo
if [[ $EUID -ne 0 ]]; then
   echo "Ce script doit être exécuté en tant que root ou avec sudo" 
   exit 1
fi

# 1. Vérifier si Docker est installé
echo "Vérification de l'installation de Docker..."

if ! command -v docker &> /dev/null; then
    echo "Docker n'est pas installé. Veuillez installer Docker avant d'exécuter ce script."
    exit 1
fi

# 2. Vérifier si Docker Compose est installé
echo "Vérification de l'installation de Docker Compose..."

if ! command -v docker-compose &> /dev/null; then
    echo "Docker Compose n'est pas installé. Veuillez installer Docker Compose avant d'exécuter ce script."
    exit 1
fi

# 3. Créer un fichier docker-compose.yml pour Zabbix
echo "Création du fichier docker-compose.yml pour Zabbix..."

cat <<EOF > /home/$(whoami)/zabbix-docker-compose.yml
version: '3.7'

services:
  zabbix-server:
    image: zabbix/zabbix-server-mysql:latest
    container_name: zabbix-server
    restart: always
    environment:
      DB_SERVER_HOST: zabbix-db
      MYSQL_USER: zabbix
      MYSQL_PASSWORD: zabbix_password
      MYSQL_DATABASE: zabbix
    ports:
      - "10051:10051"  # Port pour accéder au serveur Zabbix
    depends_on:
      - zabbix-db
    networks:
      - zabbix_network

  zabbix-web:
    image: zabbix/zabbix-web-nginx-mysql:latest
    container_name: zabbix-web
    restart: always
    environment:
      ZBX_SERVER_HOST: zabbix-server
      DB_SERVER_HOST: zabbix-db
      MYSQL_USER: zabbix
      MYSQL_PASSWORD: zabbix_password
      MYSQL_DATABASE: zabbix
    ports:
      - "8080:8080"  # Port pour l'interface Web Zabbix
    depends_on:
      - zabbix-server
    networks:
      - zabbix_network

  zabbix-db:
    image: mysql:5.7
    container_name: zabbix-db
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: rootpassword
      MYSQL_DATABASE: zabbix
      MYSQL_USER: zabbix
      MYSQL_PASSWORD: zabbix_password
    volumes:
      - zabbix_db_data:/var/lib/mysql
    networks:
      - zabbix_network

networks:
  zabbix_network:
    driver: bridge

volumes:
  zabbix_db_data:
EOF

# 4. Démarrer les conteneurs Docker avec Docker Compose
echo "Démarrage des conteneurs Zabbix..."

# Accéder au répertoire contenant le fichier docker-compose.yml
cd /home/$(whoami)

# Démarrer les services via Docker Compose
docker compose -f zabbix-docker-compose.yml up -d

# 5. Vérification de l'état des conteneurs
echo "Vérification de l'état des conteneurs..."
docker ps

echo "Installation et démarrage de Zabbix terminés avec succès !"

echo "Vous pouvez maintenant accéder à l'interface Web Zabbix sur : http://localhost:8080"
