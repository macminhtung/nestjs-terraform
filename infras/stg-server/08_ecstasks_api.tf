# ECS TASK DEFINITION [flaia-ecs-task]
resource "aws_ecs_task_definition" "flaia-ecs-task" {
  family        = "flaia-app_${var.stage}"
  task_role_arn = aws_iam_role.ecs-role.arn
  container_definitions = jsonencode([
    {
      "name" : "flaia-app",
      "cpu" : 256,
      "environment" : [
        {
          "name" : "PG_HOST",
          "value" : "{aws_db_instance.flaia-app.address}"
        },
        {
          "name" : "PG_DB",
          "value" : "${var.rds_db_name}"
        },
        {
          "name" : "PG_USER",
          "value" : "${var.rds_username}"
        },
        {
          "name" : "PG_PASSWORD",
          "value" : "${var.rds_password}"
        },
      ],
      "essential" : true,
      "image" : "${aws_ecr_repository.flaia-repository.repository_url}:latest",
      "memory" : 1024,
      "memoryReservation" : 128,
      "networkMode" : "awsvpc",
      "portMappings" : [
        {
          "containerPort" : 3001
        }
      ],
      "logConfiguration" : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-group" : "${aws_cloudwatch_log_group.flaia-app-log-group.name}",
          "awslogs-region" : "${var.region}",
          "awslogs-stream-prefix" : "${aws_cloudwatch_log_stream.flaia-app-log-stream.name}"
        }
      }
    }
  ])

  volume {
    name      = "flaia-app"
    host_path = "/ecs/flaia-app"
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [${var.availability_zones[0]}, ${var.availability_zones[1]}]"
  }
}
