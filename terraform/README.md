# Déploiement Terraform sur AWS

## 📋 Vue d'ensemble du projet

Ce projet déploie automatiquement et de manière sécurisée un forum anonyme sur AWS EC2 utilisant Terraform. Il fait partie d'un projet plus large qui valide les compétences en DevOps et DevSecOps.

**📖 Consultez le [README principal](../README.md) pour une vue d'ensemble complète du projet, incluant l'architecture applicative, les technologies utilisées et les objectifs pédagogiques.**

### 🎯 Objectifs du déploiement

Ce déploiement vise à valider les compétences suivantes :

- **Sécurité à tous les niveaux** : Intégration de vérifications de sécurité dans la CI/CD
- **Hébergement cloud** : Déploiement sur AWS EC2 (IaaS) avec infrastructure as code
- **DevSecOps** : Automatisation sécurisée du déploiement avec surveillance continue
- **CI/CD complète** : Pipeline intégrant tests E2E, analyse de sécurité et déploiement automatique
- **Observabilité** : Monitoring et surveillance de l'infrastructure déployée

### 🏗️ Architecture déployée

Le projet déploie quatre services sur des instances EC2 distinctes :

1. **API** (Node.js/Express) : Gestion des messages du forum
2. **DB** (MySQL) : Persistance des données
3. **Thread** : Interface de lecture des messages (port 80)
4. **Sender** : Interface d'envoi de messages (port 80)

## 🚀 Pipeline CI/CD

### Workflows GitHub Actions

Le projet utilise deux workflows principaux pour une séparation claire des responsabilités :

#### 1. `deploy-images.yml` - Pipeline Docker CI
**Déclencheur** : Push sur la branche `develop`

Étapes :
- **Validation du code** : Linting, formatting, analyse SAST (analyse statique de sécurité)
- **Détection de secrets** : Scan automatique des secrets dans le code
- **Tests** : Tests unitaires et d'intégration
- **Construction** : Build des images Docker avec tag basé sur le hash du commit
- **Publication** : Push des images sur GitHub Container Registry

#### 2. `terraform-deploy.yml` - Pipeline Infrastructure CD
**Déclencheur** : Push sur `main` (automatique) ou manuel

Étapes :
- **Initialisation** : Configuration Terraform avec backend Cloud
- **Validation** : Vérification de la syntaxe Terraform
- **Plan** : Génération du plan de déploiement
- **Application** : Déploiement automatique sur AWS
- **Destruction** : Option manuelle pour nettoyer l'infrastructure

### 🔒 Aspects Sécurité intégrés

- **Analyse SAST** : Détection de vulnérabilités dans le code source
- **Scan de secrets** : Prévention des fuites de credentials
- **Security Groups** : Réseau sécurisé avec accès minimal
- **Isolation** : Services backend non exposés publiquement
- **Terraform Cloud** : Gestion sécurisée de l'état Terraform

### 📊 Gestion des versions

- **Conventional Commits** : Tous les commits suivent la convention pour génération automatique des changelogs
- **Versioning automatique** : Release Please génère les versions basées sur les commits
- **Rollback** : Possibilité de revenir à la version précédente via les tags Git

## 📋 Prérequis

- Terraform installé (>= 1.0)
- AWS CLI configuré avec vos credentials
- Compte AWS actif
- Organisation Terraform Cloud configurée

## 🚀 Déploiement

### Configuration Terraform Cloud

Le projet utilise Terraform Cloud pour la gestion d'état distante :

```hcl
terraform {
  cloud {
    organization = "anonymous-forum-prod"
    workspaces {
      name = "aws-infra"
    }
  }
}
```

### 1. Initialiser Terraform

```bash
cd terraform
terraform init
```

### 2. Vérifier le plan de déploiement

```bash
terraform plan
```

### 3. Déployer l'infrastructure

```bash
terraform apply
```

Terraform va créer :
- ✅ 4 instances EC2 (DB, API, Thread, Sender)
- ✅ Security groups configurés
- ✅ Paire de clés SSH
- ✅ Réseau sécurisé entre services

### 4. Récupérer les URLs d'accès

Après le déploiement, Terraform affiche les URLs :

```bash
terraform output forum_access
```

## 🌐 Accès à l'application

- **Thread (Lecture)** : `http://<thread_ip>`
- **Sender (Envoi)** : `http://<sender_ip>`
- **API** : Non exposé publiquement (accès interne uniquement)

## 🔧 Configuration automatique

### Découverte de services

Les instances utilisent AWS CLI pour découvrir dynamiquement les IPs des autres services via les tags EC2 :

```bash
# Exemple de découverte d'IP API
API_IP=$(aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=*-api" \
  --query 'Reservations[0].Instances[0].PublicIpAddress' \
  --output text)
```

### Variables d'environnement injectées

Les conteneurs reçoivent automatiquement les configurations nécessaires :

- **Thread/Sender** : `API_HOST=<api_ip>:3000`
- **API** : `DB_HOST=<db_private_ip>`

## 🧹 Nettoyage

Pour détruire toutes les ressources créées :

```bash
terraform destroy
```

## ⚙️ Variables personnalisables

Éditez `variables.tf` ou créez un fichier `terraform.tfvars` :

```hcl
aws_region      = "eu-central-1"
student_prefix  = "votre-nom"
instance_type   = "t2.nano"
```

## 🔒 Sécurité

- **Security Groups** : Accès restreint aux ports nécessaires uniquement
- **Base de données** : Accessible uniquement depuis l'API (IP privée)
- **Clés SSH** : Générées automatiquement et stockées localement
- **Réseau** : Isolation des services backend

## 📝 Notes importantes

- ⏱️ **Déploiement** : ~5-10 minutes (installation Docker, clone repo, build images)
- 🔄 **Résilience** : Conteneurs redémarrent automatiquement en cas de crash
- 🐳 **Docker** : Déploiement natif avec `docker run` (pas de Docker Compose)
- ☁️ **Terraform Cloud** : État partagé pour collaboration et historique
- 🔐 **Sécurité** : Analyse automatique des vulnérabilités et secrets

## 🔄 Rollback et gestion des versions

### Rollback automatique

En cas de problème avec une nouvelle version :

1. Identifier le tag de la version précédente
2. Déclencher un déploiement manuel avec ce tag
3. Terraform applique automatiquement les changements

### Versions disponibles

Consultez les [releases GitHub](https://github.com/Pagiestm/Anonymous-forum/releases) pour voir toutes les versions déployables.
