  output "alb_dns_name" {
    description = "DNS name of the ALB"
    value       = aws_lb.main.dns_name
  }

  output "ecr_repository_url" {
    description = "ECR repository URL"
    value       = aws_ecr_repository.main.repository_url
  }
/*
  output "vpc_id" {
    description = "VPC ID"
    value       = aws_vpc.main.id
  }*/

  output "ecs_cluster_name" {
    description = "ECS cluster name"
    value       = aws_ecs_cluster.main.name
  }

  output "codebuild_project_name" {
    description = "CodeBuild project name"
    value       = aws_codebuild_project.main.name
  }

  output "codepipeline_name" {
    description = "CodePipeline name"
    value       = aws_codepipeline.main.name
  }
/*
  #-----------------------------------------------------------------------------
  # Outputs - so other modules (like alb.tf and ecs.tf) can use them automatically
  # -----------------------------------------------------------------------------

  output "vpc_id" {
    value = local.vpc_id
  }

  output "public_subnet_ids" {
    value = local.public_subnet_ids
  }

  output "private_subnet_ids" {
    value = local.private_subnet_ids
  }

  */