variable "aws_region" {
  description = "Región donde se creará la instancia"
  type = string
  default = "us-east-1"
}

variable "instance_type" {
  description = "Tipo de instancia a crear"
  type = string
  default = "t3.small"
}

variable "scaling_min_size" {
  type = number
  default = 1
}

variable "scaling_max_size" {
  type = number
  default = 2
}

variable "desired_size" {
  type = number
  default = 1
}

variable "github_repository" {
  type = string
  default = "AntJZs/ParcialFinal-CNube-AWS-TF"
}

variable "instance_name" {
  description = "Nombre de la instancia a crear."
  type = string
  default = "ec2-tf"
}

variable "container_name" {
  type = string
  default = "httpd-app"
}

variable "container_port" {
  type = number
  default = 80
}


variable "domain_name" {
  type = string
  default = "final.slac.space"
}
