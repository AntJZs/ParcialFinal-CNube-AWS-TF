resource "aws_cloudwatch_log_group" "codebuild" {
  name              = "/aws/codebuild/${local.name_prefix}-build"
  retention_in_days = var.log_retention_days

  tags = {
    Name = "${local.name_prefix}-build-logs"
  }
}

resource "aws_codebuild_project" "build" {
  name          = "${local.name_prefix}-build"
  description   = "Builds Docker image for ${var.container_name} and pushes to ECR"
  service_role  = aws_iam_role.codebuild.arn
  build_timeout = 15

  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec.yml"
  }

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true

    environment_variable {
      name  = "ECR_REPOSITORY_URI"
      value = aws_ecr_repository.app.repository_url
    }

    environment_variable {
      name  = "CONTAINER_NAME"
      value = var.container_name
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name = aws_cloudwatch_log_group.codebuild.name
      status     = "ENABLED"
    }
  }

  tags = {
    Name = "${local.name_prefix}-codebuild"
  }
}
