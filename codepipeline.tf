# -----------------------------------------------------------------------------
# S3 Artifact Bucket
# -----------------------------------------------------------------------------
resource "aws_s3_bucket" "artifacts" {
  bucket_prefix = "${local.name_prefix}-artifacts-"
  force_destroy = true

  tags = {
    Name = "${local.name_prefix}-artifacts"
  }
}

resource "aws_s3_bucket_versioning" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# -----------------------------------------------------------------------------
# CodeConnections (GitHub Connection)
# -----------------------------------------------------------------------------
resource "aws_codeconnections_connection" "github" {
  name          = "${local.name_prefix}-github"
  provider_type = "GitHub"

  tags = {
    Name = "${local.name_prefix}-github-conn"
  }
}

# -----------------------------------------------------------------------------
# SNS Topic for Manual Approval
# -----------------------------------------------------------------------------
resource "aws_sns_topic" "approval" {
  name = "${local.name_prefix}-approval-topic"

  tags = {
    Name = "${local.name_prefix}-approval"
  }
}

resource "aws_sns_topic_subscription" "approval" {
  count     = var.approval_email != "" ? 1 : 0
  topic_arn = aws_sns_topic.approval.arn
  protocol  = "email"
  endpoint  = var.approval_email
}

# -----------------------------------------------------------------------------
# CodePipeline
# -----------------------------------------------------------------------------
resource "aws_codepipeline" "pipeline" {
  name          = "${local.name_prefix}-pipeline"
  role_arn      = aws_iam_role.codepipeline.arn
  pipeline_type = "V1"

  artifact_store {
    location = aws_s3_bucket.artifacts.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "GitHubSource"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["SourceOutput"]

      configuration = {
        ConnectionArn        = aws_codeconnections_connection.github.arn
        FullRepositoryId     = var.github_repository
        BranchName           = var.github_branch
        DetectChanges        = "true"
        OutputArtifactFormat = "CODE_ZIP"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "DockerBuild"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["SourceOutput"]
      output_artifacts = ["BuildOutput"]

      configuration = {
        ProjectName = aws_codebuild_project.build.name
      }
    }
  }

  stage {
    name = "Approve"

    action {
      name     = "ManualApproval"
      category = "Approval"
      owner    = "AWS"
      provider = "Manual"
      version  = "1"

      configuration = {
        NotificationArn = aws_sns_topic.approval.arn
        CustomData      = "Approve deployment of new container image to ECS service ${aws_ecs_service.app.name}?"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "DeployECS"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      version         = "1"
      input_artifacts = ["BuildOutput"]

      configuration = {
        ClusterName       = aws_ecs_cluster.main.name
        ServiceName       = aws_ecs_service.app.name
        FileName          = "imagedefinitions.json"
        DeploymentTimeout = "15"
      }
    }
  }

  tags = {
    Name = "${local.name_prefix}-pipeline"
  }
}
