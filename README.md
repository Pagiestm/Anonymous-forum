# Mon Forum Anonyme

[![Version](https://img.shields.io/github/v/release/Pagiestm/Anonymous-forum)](https://github.com/Pagiestm/Anonymous-forum/releases)
[![Changelog](https://img.shields.io/badge/changelog-view-blue)](CHANGELOG.md)

## Objectifs du Projet

Ce projet vise à valider les compétences suivantes :

- Création d'une image Docker
- Mise en place d'un environnement de développement avec Docker Compose
- Établissement d'une pipeline CI/CD sur Github
- Accès à une image Docker sur un serveur distant via le Registry de Github
- Utilisation des Networks et Volumes pour la persistance des données et la sécurité sur un serveur distant

## Description du Projet

L'objectif est de concevoir un forum anonyme permettant aux utilisateurs de publier des messages sous un pseudonyme pour interagir avec les autres membres. Aucun système de création de compte/connexion n'est requis, chaque utilisateur devant utiliser un pseudonyme unique pour communiquer et être identifié.

### Fonctionnalités principales

- **Publication de messages** : Les utilisateurs peuvent publier des messages sous un pseudonyme de leur choix
- **Consultation des messages** : Affichage de tous les messages postés sur le forum
- **Interface simple et intuitive** : Deux interfaces distinctes pour la lecture et l'écriture de messages
- **Persistance des données** : Les messages sont stockés dans une base de données MySQL

### Architecture technique

Le projet est composé de quatre services principaux fonctionnant dans des conteneurs isolés :

1. **API** : Service backend en Node.js/Express qui expose les endpoints pour :

   - GET /messages : Récupérer tous les messages
   - POST /message : Créer un nouveau message
   - Cette API est isolée du réseau externe pour des raisons de sécurité

2. **DB** : Base de données MySQL qui persiste les messages dans :

   - Une table `messages` contenant les champs (id, author, content, date)
   - Utilise un volume Docker pour garantir la persistance des données

3. **Thread** : Interface frontend légère qui consomme l'API pour afficher les messages

4. **Sender** : Interface permettant la création de nouveaux messages

## Technologies utilisées

- **API** : Node.js avec Express
- **Base de données** : MySQL 8
- **Frontend** : HTML, CSS, JavaScript
- **Conteneurisation** : Docker & Docker Compose
- **CI/CD** : GitHub Actions
- **Gestion de version** : Conventional Commits, release-it

## Architecture du projet

```
anonymous-forum/
├──.github/workflows/    # Configuration des workflows CI/CD
├── api/                 # Service API
│   ├── Dockerfile       # Configuration Docker pour l'API
│   └── ...              # Code source de l'API
├── db/                  # Configuration de la base de données
│   ├──init.sql          # Script d'initialisation de la base de données
├── thread/              # Service d'affichage des messages
│   ├── Dockerfile       # Configuration Docker pour Thread
│   └── ...              # Code source du frontend d'affichage
├── sender/              # Service d'envoi des messages
│   ├── Dockerfile       # Configuration Docker pour Sender
│   └── ...              # Code source du frontend d'envoi
├── docker-compose.yml   # Configuration Docker Compose
├── CHANGELOG.md         # Historique des modifications automatisé
└── README.md            # Documentation du projet
```

## Réseaux Docker

Le projet utilise deux réseaux Docker distincts pour assurer la sécurité :

- **backend** : Réseau interne isolé d'Internet où se trouvent l'API et la base de données
- **frontend** : Réseau exposé où se trouvent les interfaces utilisateur Thread et Sender

## CI/CD Pipeline

Le dépôt est lié à une pipeline CI/CD permettant à chaque commit de passer par les étapes suivantes :

1. **Validation** : Vérification du code des services (linting, formatting)
2. **Tests** : Lancement des tests (unitaires, d'intégration)
3. **Construction** : Génération de l'image Docker pour chaque service, avec le tag de l'image correspondant au hash court du commit
4. **Déploiement** : Push de l'image Docker générée sur GitHub Container Registry

### Workflows GitHub Actions

| Workflow              | Description                              | Déclencheur               |
| --------------------- | ---------------------------------------- | ------------------------- |
| **deploy-images.yml** | Construit et publie les images Docker    | Push sur `develop`        |
| **release.yml**       | Génère une nouvelle version et changelog | Push sur `main` ou manuel |

## Gestion des versions

Ce projet suit la convention [Conventional Commits](https://www.conventionalcommits.org/) pour faciliter la gestion des versions et la génération automatisée des changelogs. Consultez le [CHANGELOG](CHANGELOG.md) pour voir l'historique des modifications.

### Types de commits utilisés

- `feat`: Nouvelles fonctionnalités
- `fix`: Corrections de bugs
- `docs`: Modifications de la documentation
- `style`: Changements de formatage
- `refactor`: Refactorisation du code
- `test`: Ajout ou modification de tests
- `chore`: Modifications du build, outils, etc.

### Gestion automatisée des versions avec Release Please

Ce projet utilise Release Please pour automatiser la gestion des versions et la génération des changelogs basées sur les commits conventionnels.

#### Création de commits conventionnels

Structurez vos messages de commit selon la convention:

type(scope): message

Exemple: `feat(api): ajouter l'endpoint pour trier les messages`

Les types de commits déterminent automatiquement l'incrémentation de version:

- fix: → incrémente la version PATCH (1.0.0 → 1.0.1)

```
fix(api): corriger la validation des champs vides

Le serveur acceptait des messages avec des pseudos vides,
ce qui causait des problèmes d'affichage.
```

- feat: → incrémente la version MINOR (1.0.0 → 1.1.0)

```
feat(thread): ajouter la pagination des messages

Implémente une pagination avec 5 messages par page pour
améliorer les performances et l'expérience utilisateur.
```

- feat: avec BREAKING CHANGE: dans le corps → incrémente la version MAJOR (1.0.0 → 2.0.0)

```
feat(api): refondre l'API des messages

BREAKING CHANGE: La structure de l'API a été modifiée.
- GET /api/messages retourne maintenant un objet avec pagination
- Les champs 'author' sont renommés en 'pseudo'
- Format de date modifié de ISO à timestamp
```

- Autres types (docs, style, refactor, etc.) → n'incrémentent pas la version

### Processus de release automatisé

1. Quand vous poussez des commits sur la branche main, Release Please analyse les commits depuis la dernière release.

2. Si des commits significatifs sont détectés (fix, feat ou BREAKING CHANGE), Release Please:

- Crée automatiquement une pull request qui:
  - Met à jour la version dans package.json
  - Met à jour le CHANGELOG.md
  - Prépare les autres fichiers nécessaires

3. Pour finaliser la release:

- Examinez et approuvez la pull request
- Fusionnez-la dans la branche main
- Release Please créera automatiquement:
  - Un tag Git pour la nouvelle version
  - Une release GitHub avec les notes de changements
  - Déclenchera le workflow de déploiement

### Forcer manuellement une release

Dans de rares cas où vous devriez forcer manuellement une release, vous pouvez:

1. Créer une pull request manuelle qui:

- Met à jour la version dans package.json
- Met à jour le CHANGELOG.md

2. Une fois fusionnée, créez une release GitHub manuelle:

- Accédez à la page "Releases" sur GitHub
- Cliquez sur "Draft a new release"
- Entrez le tag pour la version (par exemple v1.1.0)
- Remplissez les notes de changements
- Publiez la release

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

- ✅ Automatisation de la gestion des versions grâce à la convention de commit
- ✅ Automatisation de la génération des Changelogs grâce à la convention de commit
