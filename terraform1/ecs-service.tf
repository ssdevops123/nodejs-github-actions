# Comment this out initially, we'll uncomment after first pipeline run
resource "aws_ecs_service" "main" {

 #count = var.create_ecs_service ? 1 : 0

  name            = "${var.app_name}-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.main.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  network_configuration {
    security_groups = [aws_security_group.ecs.id]
    # subnets         = aws_subnet.private[*].id
     subnets         = var.private_subnet_ids
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.main.arn
    container_name   = var.app_name
    container_port   = var.app_port
  }

  health_check_grace_period_seconds = 60

  tags = {
    Name = "${var.app_name}-service"
  }

  depends_on = [aws_lb_listener.http_forward]
}