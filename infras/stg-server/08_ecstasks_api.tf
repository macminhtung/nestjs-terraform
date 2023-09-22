# ECS TASK DEFINITION [datalake-ecs-task]
resource "aws_ecs_task_definition" "datalake-ecs-task" {
  family                    = "datalake-app_${var.stage}"
  network_mode             = "awsvpc"
  requires_compatibilities  = ["FARGATE"]
  cpu                       = 256
  memory                    = 1024
  task_role_arn             = aws_iam_role.ecs-role.arn
  execution_role_arn        = aws_iam_role.ecs-role.arn
  container_definitions = jsonencode([
    {
      "name" : "${var.project_name}-${var.stage}-container"
      "environment" : [
        {
          "name" : "PG_HOST",
          "value" : "aws_db_instance.datalake-app.address"
        },
        {
          "name" : "PG_DB",
          "value" : "var.rds_db_name"
        },
        {
          "name" : "PG_USER",
          "value" : "var.rds_username"
        },
        {
          "name" : "PG_PASSWORD",
          "value" : "var.rds_password"
        },
      ],
      "essential" : true,
      "image" : "${aws_ecr_repository.datalake-repository.repository_url}:${var.image_tag}",
      "memoryReservation" : 512, // => The minimum memory required by the container to function properly
      "portMappings" : [
        {
          "containerPort" : var.app_port
        }
      ],
      "logConfiguration" : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-group" : "${aws_cloudwatch_log_group.datalake-app-log-group.name}",
          "awslogs-region" : "${var.region}",
          "awslogs-stream-prefix" : "${aws_cloudwatch_log_stream.datalake-app-log-stream.name}"
        }
      }
    }
  ])
}
