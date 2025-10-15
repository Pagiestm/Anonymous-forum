# Déploiement Terraform sur AWS

## 📋 Prérequis

- Terraform installé (>= 1.0)
- AWS CLI configuré avec vos credentials
- Compte AWS actif

## 🚀 Déploiement

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
- ✅ 1 instance EC2 pour la base de données MySQL
- ✅ 1 instance EC2 pour l'API backend (Node.js)
- ✅ 1 instance EC2 pour l'interface Thread (lecture des messages)
- ✅ 1 instance EC2 pour l'interface Sender (envoi de messages)
- ✅ Security groups configurés
- ✅ Paire de clés SSH

### 4. Récupérer les URLs d'accès

Après le déploiement, Terraform affiche les URLs :

```bash
terraform output forum_access
```

## 🌐 Accès à l'application

- **Thread (Lecture)** : `http://<thread_ip>`
- **Sender (Envoi)** : `http://<sender_ip>`
- **API** : `http://<api_ip>:3000`

## 🔧 Configuration automatique

### Variables d'environnement injectées

Les conteneurs Docker reçoivent automatiquement l'IP publique de l'API :

- **Thread** : `API_HOST=<api_public_ip>:3000`
- **Sender** : `API_HOST=<api_public_ip>:3000`
- **API** : `DB_HOST=<db_private_ip>`

### Nginx et envsubst

Les Dockerfiles des frontends (sender/thread) utilisent `envsubst` pour substituer dynamiquement `${API_HOST}` dans la configuration Nginx au démarrage du conteneur.

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

- Les security groups sont configurés pour autoriser uniquement les ports nécessaires
- La base de données n'est accessible que par l'API (IP privée)
- Les clés SSH sont générées automatiquement et stockées localement

## 📝 Notes importantes

- ⏱️ Le déploiement prend environ 5-10 minutes (installation Docker, clone du repo, build des images)
- 🔄 Les conteneurs redémarrent automatiquement en cas de crash (`--restart always`)
- 🐳 Docker Compose n'est PAS utilisé sur AWS (déploiement natif avec `docker run`)
