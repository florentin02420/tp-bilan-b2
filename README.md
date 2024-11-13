# tp-bilan-b2
Déploiement de Wordpress et Zabbix avec Docker

# Installation de Docker :
Dans un premier temps exécuter le script install_docker.sh, penser à donner les droits au fichier en éxecutant la commande : chmod +x install_docker.sh
Pour exécuter le fichier, se connecter en root se rendre dans le dossier ou se trouve le script et taper la commande suivante : ./install_docker.sh

# Installation de WordPress :
Même manipulation que pour exécuter le fichier d'installation de Docker chmod +x install_wordpress.sh et ./install_wordpress.sh
Où utiliser la commande docker run --name some-wordpress -p 8081:80 -d wordpress pour créer vous-même le contener Docker.

# Installation de Zabbix :
Se rendre dans le doccier ou le script est stocké, donner les droits d'exécution au script avec la commande chmod +x install_zabbix.sh et lancer le script avec la commande ./install_zabbix.sh
