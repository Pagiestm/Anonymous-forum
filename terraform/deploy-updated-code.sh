#!/bin/bash

# Script pour déployer le code modifié avec les bonnes URLs
echo "🚀 Déploiement du code modifié sur les instances..."

# Récupération des IPs depuis Terraform
THREAD_IP=$(terraform output -raw thread_public_ip)
SENDER_IP=$(terraform output -raw sender_public_ip)
API_PRIVATE_IP=$(terraform output -raw api_private_ip)

echo "📍 IPs détectées:"
echo "  - Thread: $THREAD_IP"
echo "  - Sender: $SENDER_IP:8080"
echo "  - API: $API_PRIVATE_IP:3000"

# Copie et déploiement du code Thread modifié
echo "🔄 Déploiement du code Thread modifié..."
scp -i distrib-forum-key.pem -o StrictHostKeyChecking=no ../thread/index.js ec2-user@$THREAD_IP:/home/ec2-user/anonymous-forum/thread/

ssh -i distrib-forum-key.pem -o StrictHostKeyChecking=no ec2-user@$THREAD_IP << EOF
  cd /home/ec2-user/anonymous-forum/thread
  docker stop forum-thread
  docker rm forum-thread
  docker build -t forum-thread .
  docker run -d \
    --name forum-thread \
    --restart always \
    -p 80:80 \
    -e API_URL=http://$API_PRIVATE_IP:3000 \
    -e SENDER_URL=http://$SENDER_IP:8080 \
    forum-thread
  echo "✅ Thread code updated and deployed"
EOF

# Copie et déploiement du code Sender modifié
echo "🔄 Déploiement du code Sender modifié..."
scp -i distrib-forum-key.pem -o StrictHostKeyChecking=no ../sender/index.js ec2-user@$SENDER_IP:/home/ec2-user/anonymous-forum/sender/

ssh -i distrib-forum-key.pem -o StrictHostKeyChecking=no ec2-user@$SENDER_IP << EOF
  cd /home/ec2-user/anonymous-forum/sender
  docker stop forum-sender
  docker rm forum-sender
  docker build -t forum-sender .
  docker run -d \
    --name forum-sender \
    --restart always \
    -p 8080:8080 \
    -e API_URL=http://$API_PRIVATE_IP:3000 \
    -e THREAD_URL=http://$THREAD_IP \
    forum-sender
  echo "✅ Sender code updated and deployed"
EOF

echo "🎉 Code modifié déployé avec succès !"
echo ""
echo "🌐 Accès aux services avec liens corrigés :"
echo "  - Thread (Lecture): http://$THREAD_IP"
echo "  - Sender (Écriture): http://$SENDER_IP:8080"
echo ""
echo "🧪 Test des liens de navigation :"
echo "curl -s http://$THREAD_IP | grep 'href.*8080'"
