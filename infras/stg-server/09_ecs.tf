# ECS [CLUSTER]: Initialize ecs cluster
resource "aws_ecs_cluster" "datalake-app" {
  name = "${var.project_name}-${var.stage}-cluster"
}

# ECS [SERVICE]: Initialize ecs service
resource "aws_ecs_service" "datalake-app" {
  name            = "${var.project_name}-${var.stage}-service"
  cluster         = aws_ecs_cluster.datalake-app.id
  task_definition = aws_ecs_task_definition.datalake-ecs-task.arn
  desired_count   = 2 // <== Number of task definition to keep running on ecs service
  depends_on      = [aws_iam_role_policy.ecs-instance-role-policy]
  launch_type           = "FARGATE"

  network_configuration {
    security_groups = [aws_security_group.ecs.id]
    subnets         = [aws_subnet.private-subnet-1.id, aws_subnet.private-subnet-2.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.datalake-app.arn
    container_name   = "${var.project_name}-${var.stage}-container"
    container_port   = 3001
  }
}
