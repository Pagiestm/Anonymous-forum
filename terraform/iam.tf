# Rôle IAM pour les instances EC2
resource "aws_iam_role" "ec2_ssm_role" {
  name = "${var.student_prefix}-forum-ec2-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "${var.student_prefix}-forum-ec2-ssm-role"
  }
}

# Policy pour accéder à Parameter Store
resource "aws_iam_role_policy" "ssm_parameter_access" {
  name = "${var.student_prefix}-forum-ssm-parameter-access"
  role = aws_iam_role.ec2_ssm_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssm:GetParameter",
          "ssm:GetParameters",
          "ssm:GetParametersByPath"
        ]
        Resource = "arn:aws:ssm:${var.aws_region}:*:parameter/${var.student_prefix}/forum/*"
      }
    ]
  })
}

# Instance profile pour attacher le rôle aux instances EC2
resource "aws_iam_instance_profile" "ec2_ssm_profile" {
  name = "${var.student_prefix}-forum-ec2-ssm-profile"
  role = aws_iam_role.ec2_ssm_role.name

  tags = {
    Name = "${var.student_prefix}-forum-ec2-ssm-profile"
  }
}
