# Workflows CI/CD GitHub Actions

## 📋 Vue d'ensemble

Ce dossier contient les workflows GitHub Actions qui automatisent le processus de développement, test, construction et déploiement du forum anonyme. Les workflows sont conçus pour assurer une séparation claire des responsabilités entre la construction des images Docker et le déploiement de l'infrastructure.

## 🚀 Workflows disponibles

### 1. `deploy-images.yml` - Pipeline CI Docker

**📍 Emplacement** : `.github/workflows/deploy-images.yml`  
**🔥 Déclencheur** : Push sur la branche `develop`  
**🎯 Objectif** : Construire, tester et publier les images Docker

#### Étapes du workflow :

1. **Checkout du code**
   ```yaml
   - uses: actions/checkout@v4
   ```

2. **Configuration Node.js**
   ```yaml
   - uses: actions/setup-node@v4
     with:
       node-version: '18'
   ```

3. **Installation des dépendances**
   ```yaml
   - name: Install dependencies
     run: |
       cd api && npm ci
       cd ../thread && npm ci
       cd ../sender && npm ci
   ```

4. **🔒 Vérification des secrets**
   ```yaml
   - name: Run Trivy vulnerability scanner
     uses: aquasecurity/trivy-action@master
     with:
       scan-type: 'fs'
       scan-ref: '.'
       format: 'sarif'
       output: 'trivy-results.sarif'
   ```

5. **🛡️ Analyse SAST (Static Application Security Testing)**
   ```yaml
   - name: Run Trivy vulnerability scanner for SAST
     uses: aquasecurity/trivy-action@master
     with:
       scan-type: 'config'
       scan-ref: '.'
   ```

6. **Validation du code**
   ```yaml
   - name: Lint API
     run: cd api && npm run lint
   - name: Lint Thread
     run: cd thread && npm run lint
   - name: Lint Sender
     run: cd sender && npm run lint
   ```

7. **Tests unitaires**
   ```yaml
   - name: Test API
     run: cd api && npm test
   - name: Test Thread
     run: cd thread && npm test
   - name: Test Sender
     run: cd sender && npm test
   ```

8. **Construction des images Docker**
   ```yaml
   - name: Build API image
     run: |
       docker build -t ghcr.io/${{ github.repository }}/api:${{ github.sha }} ./api
   - name: Build Thread image
     run: |
       docker build -t ghcr.io/${{ github.repository }}/thread:${{ github.sha }} ./thread
   - name: Build Sender image
     run: |
       docker build -t ghcr.io/${{ github.repository }}/sender:${{ github.sha }} ./sender
   ```

9. **Publication sur GitHub Container Registry**
   ```yaml
   - name: Login to GitHub Container Registry
     uses: docker/login-action@v3
     with:
       registry: ghcr.io
       username: ${{ github.actor }}
       password: ${{ secrets.GITHUB_TOKEN }}

   - name: Push images
     run: |
       docker push ghcr.io/${{ github.repository }}/api:${{ github.sha }}
       docker push ghcr.io/${{ github.repository }}/thread:${{ github.sha }}
       docker push ghcr.io/${{ github.repository }}/sender:${{ github.sha }}
   ```

### 2. `terraform-deploy.yml` - Pipeline CD Infrastructure

**📍 Emplacement** : `.github/workflows/terraform-deploy.yml`  
**🔥 Déclencheur** : Push sur `main` (automatique) ou workflow dispatch (manuel)  
**🎯 Objectif** : Déployer l'infrastructure AWS avec Terraform

#### Étapes du workflow :

1. **Checkout du code**
   ```yaml
   - uses: actions/checkout@v4
   ```

2. **Configuration AWS CLI**
   ```yaml
   - name: Configure AWS credentials
     uses: aws-actions/configure-aws-credentials@v4
     with:
       aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
       aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
       aws-region: eu-central-1
   ```

3. **Configuration Terraform**
   ```yaml
   - name: Setup Terraform
     uses: hashicorp/setup-terraform@v3
     with:
       terraform_version: "1.5.0"
   ```

4. **Initialisation Terraform Cloud**
   ```yaml
   - name: Terraform Init
     run: |
       cd terraform
       terraform init
     env:
       TF_TOKEN_app_terraform_io: ${{ secrets.TF_API_TOKEN }}
   ```

5. **Validation de la configuration**
   ```yaml
   - name: Terraform Validate
     run: |
       cd terraform
       terraform validate
   ```

6. **Génération du plan**
   ```yaml
   - name: Terraform Plan
     run: |
       cd terraform
       terraform plan -out=tfplan
   ```

7. **Déploiement automatique**
   ```yaml
   - name: Terraform Apply
     run: |
       cd terraform
       terraform apply -auto-approve tfplan
   ```

8. **Récupération des outputs**
   ```yaml
   - name: Get outputs
     run: |
       cd terraform
       terraform output forum_access
   ```

## 🔒 Aspects Sécurité Intégrés

### Vérification des Secrets

La pipeline utilise **Trivy** pour scanner automatiquement les secrets dans le code source :

- **Outil** : `aquasecurity/trivy-action`
- **Type de scan** : `fs` (filesystem)
- **Format de sortie** : SARIF pour intégration GitHub Security
- **Déclencheur** : À chaque push sur `develop`

### Analyse SAST (Static Application Security Testing)

L'analyse statique de sécurité détecte les vulnérabilités dans :

- **Code source** : Recherche de patterns dangereux
- **Configuration** : Fichiers de config, Dockerfiles, etc.
- **Dépendances** : Vulnérabilités dans les packages
- **Outil** : Trivy avec scan-type `config`
- **Intégration** : Résultats uploadés vers GitHub Security tab

## 🏗️ Architecture des Pipelines

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   develop       │ => │  deploy-images   │ => │  Images built   │
│   branch push   │    │  workflow        │    │  & published    │
└─────────────────┘    └──────────────────┘    └─────────────────┘
                                                            │
┌─────────────────┐    ┌──────────────────┐           │
│   main branch   │ => │ terraform-deploy │ <= Images │
│   push          │    │ workflow         │           │
└─────────────────┘    └──────────────────┘           │
           │                                         │
           ▼                                         ▼
┌─────────────────┐                         ┌─────────────────┐
│ Infrastructure  │ <= = = = = = = = = = => │   AWS EC2        │
│ deployed        │                         │   instances      │
└─────────────────┘                         └─────────────────┘
```

## 📊 Métriques et Rapports

### Tests et Qualité
- **Coverage** : Rapports de couverture des tests
- **Linting** : Conformité du code aux standards
- **Security** : Alertes de sécurité dans l'onglet Security de GitHub

### Déploiement
- **Durée** : ~5-10 minutes pour déploiement complet
- **Outputs** : URLs d'accès affichées après déploiement
- **Rollback** : Possibilité de revenir aux versions précédentes

## 🔧 Configuration Requise

### Secrets GitHub
```
AWS_ACCESS_KEY_ID        # Clé d'accès AWS
AWS_SECRET_ACCESS_KEY    # Clé secrète AWS
TF_API_TOKEN            # Token Terraform Cloud
GITHUB_TOKEN            # Token automatique GitHub
```

### Permissions
```yaml
permissions:
  contents: read
  packages: write
  security-events: write
  id-token: write
```

## 🚨 Gestion des Erreurs

### Échecs de Tests
- Les tests qui échouent bloquent le déploiement
- Notifications automatiques sur les PRs
- Logs détaillés disponibles dans l'onglet Actions

### Échecs de Sécurité
- Alertes dans l'onglet Security
- Scan SARIF intégré à GitHub
- Possibilité de définir des seuils de criticité

## 📚 Ressources Supplémentaires

- [Documentation GitHub Actions](https://docs.github.com/en/actions)
- [Trivy Documentation](https://aquasecurity.github.io/trivy/)
- [Terraform Cloud](https://cloud.hashicorp.com/products/terraform)
- [GitHub Container Registry](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry)

---

**📖 Consultez également** :
- [README principal](../README.md) - Vue d'ensemble du projet
- [README Terraform](../terraform/README.md) - Déploiement infrastructure</content>
<parameter name="filePath">c:\Users\Théotime\Documents\MDS\MBA1\Docker\Docker\Docker\anonymous-forum\.github\workflows\README.md