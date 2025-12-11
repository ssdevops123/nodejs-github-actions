# Cloud Map namespace for Service Connect
resource "aws_service_discovery_http_namespace" "main" {
  count = var.create_service_connect_namespace && var.service_connect_namespace != "" ? 1 : 0

  name        = var.service_connect_namespace
  description = "Service Connect namespace for ${var.app_name}"
  
  tags = {
    Name = "${var.app_name}-service-connect"
  }
}

resource "aws_ecs_cluster" "main" {
  name = var.app_name

  # Service Connect configuration - only create if namespace is provided
  dynamic "service_connect_defaults" {
    for_each = var.service_connect_namespace != "" ? [1] : []
    content {
      namespace = var.create_service_connect_namespace ? aws_service_discovery_http_namespace.main[0].arn : var.service_connect_namespace
    }
  }

  # Execute Command configuration - always set, but control the logging level
  configuration {
    execute_command_configuration {
      logging = var.ecs_exec_logging
      
      # Only set KMS key if ECS Exec is enabled and KMS key is provided
      kms_key_id = var.enable_ecs_exec && var.ecs_exec_kms_key_id != "" ? var.ecs_exec_kms_key_id : null

      # Only configure log configuration if override logging is enabled
      dynamic "log_configuration" {
        for_each = var.enable_ecs_exec && var.ecs_exec_logging == "OVERRIDE" ? [1] : []
        content {
          cloud_watch_log_group_name = aws_cloudwatch_log_group.ecs_exec[0].name
        }
      }
    }
  }

  # Container Insights setting - always set explicitly
  setting {
    name  = "containerInsights"
    value = var.enable_container_insights ? "enabled" : "disabled"
  }

  tags = merge(
    {
      Name = var.app_name
    },
    var.cluster_tags
  )
}

# ... rest of the ecs.tf remains the same ...

# CloudWatch Log Group for ECS Exec (only if override logging is enabled)
resource "aws_cloudwatch_log_group" "ecs_exec" {
  count = var.enable_ecs_exec && var.ecs_exec_logging == "OVERRIDE" ? 1 : 0

  name              = "/ecs/exec/${var.app_name}"
  retention_in_days = 7

  tags = {
    Name = "${var.app_name}-ecs-exec-logs"
  }
}

# IAM Role for ECS Task Execution
data "aws_iam_policy_document" "ecs_task_execution_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "${var.app_name}-ecs-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_role.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Additional IAM policy for ECS Exec if enabled
resource "aws_iam_role_policy" "ecs_exec" {
  count = var.enable_ecs_exec ? 1 : 0

  name = "${var.app_name}-ecs-exec-policy"
  role = aws_iam_role.ecs_task_execution_role.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      }
    ]
  })
}