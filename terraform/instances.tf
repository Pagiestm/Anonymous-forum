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

resource "aws_instance" "api" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.main.key_name
  vpc_security_group_ids = [aws_security_group.api.id]
  user_data              = base64encode(local.api_user_data)

  depends_on = [aws_instance.db]

  tags = {
    Name    = "${var.student_prefix}-forum-api"
    Role    = "backend"
    Service = "api"
  }
}

resource "aws_instance" "thread" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.main.key_name
  vpc_security_group_ids = [aws_security_group.thread.id]
  user_data              = base64encode(local.thread_user_data)

  depends_on = [aws_instance.api]

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
  user_data              = base64encode(local.sender_user_data)

  depends_on = [aws_instance.api]

  tags = {
    Name    = "${var.student_prefix}-forum-sender"
    Role    = "frontend"
    Service = "sender"
  }
}
