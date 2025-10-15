output "db_instance_id" {
  value = aws_instance.db.id
}

output "db_private_ip" {
  value = aws_instance.db.private_ip
}

output "db_public_ip" {
  value = aws_instance.db.public_ip
}

output "db_ssh_command" {
  value = "ssh -i ${var.student_prefix}-forum-key.pem ec2-user@${aws_instance.db.public_ip}"
}

output "api_instance_id" {
  value = aws_instance.api.id
}

output "api_private_ip" {
  value = aws_instance.api.private_ip
}

output "api_public_ip" {
  value = aws_instance.api.public_ip
}

output "api_url" {
  value = "http://${aws_instance.api.public_ip}:3000"
}

output "api_ssh_command" {
  value = "ssh -i ${var.student_prefix}-forum-key.pem ec2-user@${aws_instance.api.public_ip}"
}

output "thread_instance_id" {
  value = aws_instance.thread.id
}

output "thread_public_ip" {
  value = aws_instance.thread.public_ip
}

output "thread_url" {
  value = "http://${aws_instance.thread.public_ip}"
}

output "thread_ssh_command" {
  value = "ssh -i ${var.student_prefix}-forum-key.pem ec2-user@${aws_instance.thread.public_ip}"
}

output "sender_instance_id" {
  value = aws_instance.sender.id
}

output "sender_public_ip" {
  value = aws_instance.sender.public_ip
}

output "sender_url" {
  value = "http://${aws_instance.sender.public_ip}"
}

output "sender_ssh_command" {
  value = "ssh -i ${var.student_prefix}-forum-key.pem ec2-user@${aws_instance.sender.public_ip}"
}

output "key_pair_name" {
  value = aws_key_pair.main.key_name
}

output "region" {
  value = var.aws_region
}

output "forum_access" {
  value = {
    thread_interface = "http://${aws_instance.thread.public_ip}"
    sender_interface = "http://${aws_instance.sender.public_ip}"
    api_endpoint     = "http://${aws_instance.api.public_ip}:3000"
  }
}
