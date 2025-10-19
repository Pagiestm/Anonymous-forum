locals {
  docker_install_script = <<-EOF
    #!/bin/bash
    yum update -y
    # Installation Docker
    amazon-linux-extras install -y docker
    systemctl start docker
    systemctl enable docker
    usermod -aG docker ec2-user
    curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
    yum install -y git
    sleep 10
  EOF

  db_user_data = <<-EOF
    ${local.docker_install_script}
    mkdir -p /home/ec2-user/mysql/data
    chown -R ec2-user:ec2-user /home/ec2-user/mysql
    docker run -d \
      --name forum-db \
      --restart always \
      -p 3306:3306 \
      -e MYSQL_ROOT_PASSWORD=forumroot \
      -e MYSQL_DATABASE=forum \
      -e MYSQL_ROOT_HOST=% \
      -v /home/ec2-user/mysql/data:/var/lib/mysql \
      mysql:8 \
      --default-authentication-plugin=mysql_native_password
    sleep 30
    echo "MySQL started successfully" > /home/ec2-user/db-status.txt
  EOF

  api_user_data = <<-EOF
    ${local.docker_install_script}
    cd /home/ec2-user
    git clone https://github.com/Pagiestm/Anonymous-forum.git
    cd Anonymous-forum/api
    chown -R ec2-user:ec2-user /home/ec2-user/Anonymous-forum
    
    # Récupérer l'IP privée de la DB via les tags AWS
    sleep 30
    DB_IP=$(aws ec2 describe-instances \
      --region ${var.aws_region} \
      --filters "Name=tag:Name,Values=${var.student_prefix}-forum-db" "Name=instance-state-name,Values=running" \
      --query 'Reservations[0].Instances[0].PrivateIpAddress' \
      --output text)
    
    # Construire et lancer l'API avec l'IP de la DB
    docker build -t forum-api .
    docker run -d \
      --name forum-api \
      --restart always \
      -p 3000:3000 \
      -e MYSQL_HOST=$DB_IP \
      -e MYSQL_PORT=3306 \
      -e MYSQL_USER=root \
      -e MYSQL_PASSWORD=forumroot \
      -e MYSQL_DATABASE=forum \
      forum-api
    echo "API started successfully with DB at $DB_IP" > /home/ec2-user/api-status.txt
  EOF

  thread_user_data = <<-EOF
    ${local.docker_install_script}
    cd /home/ec2-user
    if [ -d Anonymous-forum ]; then
      cd Anonymous-forum && git pull || true
      cd ..
    else
      git clone https://github.com/Pagiestm/Anonymous-forum.git
    fi
    cd Anonymous-forum/thread
    chown -R ec2-user:ec2-user /home/ec2-user/Anonymous-forum
    
    # Attendre que l'API soit prête et récupérer son IP via les tags AWS
    sleep 45
    API_IP=$(aws ec2 describe-instances \
      --region ${var.aws_region} \
      --filters "Name=tag:Name,Values=${var.student_prefix}-forum-api" "Name=instance-state-name,Values=running" \
      --query 'Reservations[0].Instances[0].PublicIpAddress' \
      --output text)
    
    docker build -t forum-thread .
    docker rm -f forum-thread || true
    docker run -d \
      --name forum-thread \
      --restart always \
      -p 80:80 \
      -e API_HOST=$API_IP:3000 \
      forum-thread
    echo "Thread started successfully with API at $API_IP:3000" > /home/ec2-user/thread-status.txt
  EOF

  sender_user_data = <<-EOF
    ${local.docker_install_script}
    cd /home/ec2-user
    if [ -d Anonymous-forum ]; then
      cd Anonymous-forum && git pull || true
      cd ..
    else
      git clone https://github.com/Pagiestm/Anonymous-forum.git
    fi
    cd Anonymous-forum/sender
    chown -R ec2-user:ec2-user /home/ec2-user/Anonymous-forum
    
    # Attendre que l'API soit prête et récupérer son IP via les tags AWS
    sleep 45
    API_IP=$(aws ec2 describe-instances \
      --region ${var.aws_region} \
      --filters "Name=tag:Name,Values=${var.student_prefix}-forum-api" "Name=instance-state-name,Values=running" \
      --query 'Reservations[0].Instances[0].PublicIpAddress' \
      --output text)
    
    docker build -t forum-sender .
    docker rm -f forum-sender || true
    docker run -d \
      --name forum-sender \
      --restart always \
      -p 80:80 \
      -e API_HOST=$API_IP:3000 \
      forum-sender
    echo "Sender started successfully with API at $API_IP:3000" > /home/ec2-user/sender-status.txt
  EOF
}
