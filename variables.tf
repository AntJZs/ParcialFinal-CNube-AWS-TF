variable "aws_region" {
  description = "AWS region for all resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name prefix for resources and tags"
  type        = string
  default     = "parcialfinal"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "scaling_min_size" {
  description = "Minimum number of ECS tasks (at least 2 required)"
  type        = number
  default     = 2

  validation {
    condition     = var.scaling_min_size >= 2
    error_message = "scaling_min_size must be at least 2."
  }
}

variable "scaling_max_size" {
  description = "Maximum number of ECS tasks"
  type        = number
  default     = 4

  validation {
    condition     = var.scaling_max_size >= var.scaling_min_size
    error_message = "scaling_max_size must be greater than or equal to scaling_min_size."
  }
}

variable "desired_size" {
  description = "Initial desired count for ECS tasks"
  type        = number
  default     = 2

  validation {
    condition     = var.desired_size >= var.scaling_min_size
    error_message = "desired_size must be greater than or equal to scaling_min_size."
  }
}

variable "github_repository" {
  description = "GitHub repository in format owner/repo"
  type        = string
  default     = "AntJZs/ParcialFinal-CNube-AWS-TF"
}

variable "github_branch" {
  description = "GitHub branch monitored by CodePipeline"
  type        = string
  default     = "main"
}

variable "container_name" {
  description = "Name of the container in task definition and imagedefinitions.json"
  type        = string
  default     = "httpd-app"
}

variable "container_port" {
  description = "Port exposed by the container"
  type        = number
  default     = 80
}

variable "domain_name" {
  description = "Custom domain name (e.g. final.slac.space)"
  type        = string
  default     = "final.slac.space"
}

variable "existing_acm_certificate_arn" {
  description = "ARN of the existing ACM certificate in us-east-1 to attach to ALB HTTPS listener"
  type        = string
  default     = ""
}

variable "approval_email" {
  description = "Email address for CodePipeline manual approval notifications"
  type        = string
  default     = ""
}

variable "vpc_cidr" {
  description = "CIDR block for the dedicated VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for the two public subnets in different AZs"
  type        = list(string)
  default     = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "bootstrap_image" {
  description = "Public bootstrap container image used before the first pipeline build pushes to ECR"
  type        = string
  default     = "public.ecr.aws/docker/library/httpd:2.4"
}

variable "task_cpu" {
  description = "Fargate CPU units (256 = 0.25 vCPU)"
  type        = number
  default     = 256
}

variable "task_memory" {
  description = "Fargate memory MiB"
  type        = number
  default     = 512
}

variable "health_check_path" {
  description = "Target group health check path"
  type        = string
  default     = "/"
}

variable "log_retention_days" {
  description = "CloudWatch log retention in days"
  type        = number
  default     = 7
}
