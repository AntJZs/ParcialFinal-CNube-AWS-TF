data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  name_prefix         = "${var.project_name}-${var.environment}"
  ecr_repository_name = "${var.project_name}-${var.container_name}"

  # Pick first two availability zones
  azs = slice(data.aws_availability_zones.available.names, 0, 2)
}
