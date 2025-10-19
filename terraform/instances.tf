resource "aws_instance" "db" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.main.key_name
  vpc_security_group_ids = [aws_security_group.db.id]
  user_data              = base64encode(local.db_user_data)

  tags = {
    Name    = "${var.student_prefix}-forum-db"
    Role    = "database"
    Service = "mysql"
  }
}

# Stocker l'IP privée de la DB dans Parameter Store
resource "aws_ssm_parameter" "db_private_ip" {
  name  = "/${var.student_prefix}/forum/db/private-ip"
  type  = "String"
  value = aws_instance.db.private_ip

  tags = {
    Name = "${var.student_prefix}-forum-db-ip"
  }
}

resource "aws_instance" "api" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.main.key_name
  vpc_security_group_ids = [aws_security_group.api.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_ssm_profile.name
  user_data              = base64encode(local.api_user_data)

  depends_on = [aws_instance.db, aws_ssm_parameter.db_private_ip]

  tags = {
    Name    = "${var.student_prefix}-forum-api"
    Role    = "backend"
    Service = "api"
  }
}

# Stocker l'IP publique de l'API dans Parameter Store
resource "aws_ssm_parameter" "api_public_ip" {
  name  = "/${var.student_prefix}/forum/api/public-ip"
  type  = "String"
  value = aws_instance.api.public_ip

  tags = {
    Name = "${var.student_prefix}-forum-api-ip"
  }
}

resource "aws_instance" "thread" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.main.key_name
  vpc_security_group_ids = [aws_security_group.thread.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_ssm_profile.name
  user_data              = base64encode(local.thread_user_data)

  depends_on = [aws_instance.api, aws_ssm_parameter.api_public_ip]

  tags = {
    Name    = "${var.student_prefix}-forum-thread"
    Role    = "frontend"
    Service = "thread"
  }
}

resource "aws_instance" "sender" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.main.key_name
  vpc_security_group_ids = [aws_security_group.sender.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_ssm_profile.name
  user_data              = base64encode(local.sender_user_data)

  depends_on = [aws_instance.api, aws_ssm_parameter.api_public_ip]

  tags = {
    Name    = "${var.student_prefix}-forum-sender"
    Role    = "frontend"
    Service = "sender"
  }
}
