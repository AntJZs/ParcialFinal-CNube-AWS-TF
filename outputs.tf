output "alb_dns_name" {
  description = "Public DNS name of the ALB. Create a CNAME in your external DNS provider pointing your domain to this address."
  value       = aws_lb.app.dns_name
}

output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = aws_lb.app.arn
}

output "ecr_repository_url" {
  description = "URL of the ECR repository"
  value       = aws_ecr_repository.app.repository_url
}

output "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.main.name
}

output "ecs_service_name" {
  description = "Name of the ECS service"
  value       = aws_ecs_service.app.name
}

output "codepipeline_name" {
  description = "Name of the CodePipeline"
  value       = aws_codepipeline.pipeline.name
}

output "codeconnections_connection_arn" {
  description = "ARN of the GitHub connection. Complete authorization in AWS Console (Developer Tools > Connections)."
  value       = aws_codeconnections_connection.github.arn
}

output "codeconnections_connection_status" {
  description = "Status of the GitHub connection (PENDING until authorized in Console)"
  value       = aws_codeconnections_connection.github.connection_status
}
