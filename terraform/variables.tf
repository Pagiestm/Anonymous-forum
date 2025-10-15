variable "aws_region" {
  type    = string
  default = "eu-central-1"
}

variable "student_prefix" {
  type    = string
  default = "theotime"
}

variable "instance_type" {
  type    = string
  default = "t2.nano"
}

variable "ssh_cidr" {
  type    = string
  default = "0.0.0.0/0"
}

variable "docker_hub_username" {
  type    = string
  default = ""
}

variable "docker_hub_password" {
  type      = string
  default   = ""
  sensitive = true
}
