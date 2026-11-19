locals {
  tags = {
    Project = var.project_name,
    CreatedOn = timestamp()
  }
}


resource "aws_codebuild_project" "project" {
  name = var.project_name
  service_role = aws_iam_role.project.arn

  artifacts {
    type = "f"
  }

  environment {
    com
  }
}