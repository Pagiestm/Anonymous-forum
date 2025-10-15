resource "tls_private_key" "main" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "main" {
  key_name   = "${var.student_prefix}-forum-key"
  public_key = tls_private_key.main.public_key_openssh

  tags = {
    Name = "${var.student_prefix}-forum-key"
  }
}

resource "local_file" "private_key" {
  content         = tls_private_key.main.private_key_pem
  filename        = "${path.module}/${var.student_prefix}-forum-key.pem"
  file_permission = "0600"
}
