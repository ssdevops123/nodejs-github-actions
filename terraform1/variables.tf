# global

variable "vpc_id" {
  description = "VPC ID where ALB and SG will be created"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for ALB"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for ECS tasks"
  type        = list(string)
}


variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "app_name" {
  description = "Application name"
  type        = string
  default     = "hello-world-app"
}
/*
# vpc

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "172.16.0.0/16"
}
*/
variable "enable_nat_gateway" {
  description = "Enable NAT Gateway for private subnets"
  type        = bool
  default     = false
}


# alb

variable "enable_ssl" {
  description = "Enable SSL/HTTPS listener"
  type        = bool
  default     = false
}

variable "acm_certificate_arn" {
  description = "ARN of ACM certificate for HTTPS listener"
  type        = string
  default     = ""
}

# sg 

variable "app_port" {
  description = "Application port"
  type        = number
  default     = 80
}



# ecs

variable "enable_container_insights" {
  description = "Enable CloudWatch Container Insights for ECS cluster"
  type        = bool
  default     = false
}

variable "enable_ecs_exec" {
  description = "Enable ECS Exec for running commands in containers"
  type        = bool
  default     = false
}

variable "ecs_exec_kms_key_id" {
  description = "KMS Key ID for ECS Exec session encryption"
  type        = string
  default     = ""
}

variable "ecs_exec_logging" {
  description = "Logging configuration for ECS Exec - 'DEFAULT', 'OVERRIDE', or 'NONE'"
  type        = string
  default     = "NONE"
  validation {
    condition     = contains(["DEFAULT", "OVERRIDE", "NONE"], var.ecs_exec_logging)
    error_message = "ECS Exec logging must be 'DEFAULT', 'OVERRIDE', or 'NONE'."
  }
}


variable "create_service_connect_namespace" {
  description = "Create a new Cloud Map namespace for Service Connect"
  type        = bool
  default     = false
}

variable "service_connect_namespace" {
  description = "Name for the Service Connect namespace (will be created if create_service_connect_namespace is true)"
  type        = string
  default     = ""
}

variable "service_connect_namespace_type" {
  description = "Type of Service Connect namespace - 'HTTP' or 'DNS_PRIVATE' or 'DNS_PUBLIC'"
  type        = string
  default     = "HTTP"
  validation {
    condition     = contains(["HTTP", "DNS_PRIVATE", "DNS_PUBLIC"], var.service_connect_namespace_type)
    error_message = "Service Connect namespace type must be 'HTTP', 'DNS_PRIVATE', or 'DNS_PUBLIC'."
  }
}

variable "cluster_tags" {
  description = "Additional tags for ECS cluster"
  type        = map(string)
  default     = {}
}

# task definition
variable "docker_image_tag" {
  description = "Docker image tag for ECS task definition"
  type        = string
  default     = "latest"
}

variable "use_latest_tag" {
  description = "Whether to use 'latest' tag or commit-based tags"
  type        = bool
  default     = true
}

# code pipeline

variable "github_connection_arn" {
  description = "ARN of the existing CodeStar connection for GitHub"
  type        = string
  default     = ""
}

variable "github_repo" {
  description = "GitHub repository URL"
  type        = string
}

variable "github_branch" {
  description = "GitHub branch"
  type        = string
  default     = "main"
}
 