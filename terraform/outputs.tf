output "api_url" {
  description = "URL de l'API backend"
  value       = "http://${aws_instance.api.public_ip}:3000"
}

output "thread_url" {
  description = "URL de l'interface Thread (lecture des messages)"
  value       = "http://${aws_instance.thread.public_ip}"
}

output "sender_url" {
  description = "URL de l'interface Sender (envoi de messages)"
  value       = "http://${aws_instance.sender.public_ip}"
}

output "forum_access" {
  description = "URLs d'accès au forum"
  value = {
    thread_interface = "http://${aws_instance.thread.public_ip}"
    sender_interface = "http://${aws_instance.sender.public_ip}"
    api_endpoint     = "http://${aws_instance.api.public_ip}:3000"
  }
}

output "deployment_info" {
  description = "Informations de déploiement"
  value = {
    region    = var.aws_region
    api_ip    = aws_instance.api.public_ip
    thread_ip = aws_instance.thread.public_ip
    sender_ip = aws_instance.sender.public_ip
  }
}
