# Mon Forum Anonyme

## Objectifs du Projet

Ce projet vise à valider les compétences suivantes :

- Création d'une image Docker
- Mise en place d'un environnement de développement avec Docker Compose
- Établissement d'une pipeline CI/CD sur Github
- Accès à une image Docker sur un serveur distant via le Registry de Github
- Utilisation des Networks et Volumes pour la persistance des données et la sécurité sur un serveur distant

## Description du Projet

L'objectif est de concevoir un forum anonyme permettant aux utilisateurs de publier des messages sous un pseudonyme pour interagir avec les autres membres. Aucun système de création de compte/connexion n'est requis, chaque utilisateur devant utiliser un pseudonyme unique pour communiquer et être identifié.

Dans l'environnement de développement, trois services ont été développés et une base de données déployée grâce à Docker Compose :

1. **API** : Gestion de la création et de la récupération des messages du forum. Cette API est située dans un réseau interne, isolée d'Internet, et peut interagir avec les autres services.
2. **DB** : Base de données MySQL utilisée par l'API pour stocker les messages du forum, également située dans le réseau interne.

3. **Thread** : Service chargé d'afficher les messages des utilisateurs via le port 80, consommant les services de l'API.

4. **Sender** : Service chargé d'écrire les messages des utilisateurs via le port 8080, consommant également l'API.

## Technologies utilisées

- **API** : Node.js avec Express
- **Base de données** : MySQL
- **Frontend** : HTML, CSS, JavaScript
- **Conteneurisation** : Docker & Docker Compose
- **CI/CD** : GitHub Actions

## Architecture du projet

```
anonymous-forum/
├── api/                 # Service API
│   ├── Dockerfile       # Configuration Docker pour l'API
│   └── ...              # Code source de l'API
├── thread/              # Service d'affichage des messages
│   ├── Dockerfile       # Configuration Docker pour Thread
│   └── ...              # Code source du frontend d'affichage
├── sender/              # Service d'envoi des messages
│   ├── Dockerfile       # Configuration Docker pour Sender
│   └── ...              # Code source du frontend d'envoi
├── docker-compose.yml   # Configuration Docker Compose
├── init.sql             # Script d'initialisation de la base de données
└── README.md            # Documentation du projet
```

## CI/CD Pipeline

Le dépôt est lié à une pipeline CI/CD permettant à chaque commit de passer par les étapes suivantes :

1. **Validation** : Vérification du code des services (linting, formatting)
2. **Tests** : Lancement des tests (unitaires, d'intégration)
3. **Construction** : Génération de l'image Docker pour chaque service, avec le tag de l'image correspondant au hash court du commit
4. **Déploiement** : Push de l'image Docker générée sur GitHub Container Registry

## Convention de commits

Ce projet suit la convention [Conventional Commits](https://www.conventionalcommits.org/) pour faciliter la gestion des versions et la génération automatisée des Changelogs, en utilisant l'outil [Commitizen](https://github.com/commitizen/cz-cli).

## Installation et démarrage

1. Cloner le dépôt :

```bash
git clone https://github.com/votre-username/anonymous-forum.git
cd anonymous-forum
```

2. Lancer les services avec Docker Compose :

```bash
docker-compose up -d
```

3. Accéder aux services :
   - Thread (affichage des messages) : http://localhost:80
   - Sender (envoi des messages) : http://localhost:8080
   - PHPMyAdmin : http://localhost:8081

## Évaluation

Ce projet est individuel. Un lien vers le dépôt de code est requis pour vérification avant la soutenance.

La soutenance comprendra :

1. Présentation du projet (environ 5 minutes)
2. Questions sur les choix effectués et revue technique (environ 5 minutes)

L'évaluation se basera sur 20 points, portant sur les compétences évaluées.
Le versionnage progressif du code est obligatoire tout au long du projet.

**Points bonus :**

- Automatisation de la gestion des versions grâce à la convention de commit
- Automatisation de la génération des Changelogs grâce à la convention de commit
