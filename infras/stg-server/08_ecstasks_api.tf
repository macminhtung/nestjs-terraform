# ECS TASK DEFINITION [hrforte-ecs-task]
resource "aws_ecs_task_definition" "hrforte-ecs-task" {
  family        = "hrforte-app_${var.stage}"
  task_role_arn = aws_iam_role.ecs-role.arn
  container_definitions = jsonencode([
    {
      "name" : "${var.project_name}-${var.stage}-container"
      "cpu" : 1024, // 1024 = 1vCPU
      "environment" : [
        {
          "name" : "PG_HOST",
          "value" : "aws_db_instance.hrforte-app.address"
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
      "image" : "${aws_ecr_repository.hrforte-repository.repository_url}:${var.image_tag}",
      "memory" : 1024,
      "memoryReservation" : 512, // => The minimum memory required by the container to function properly
      "networkMode" : "awsvpc",
      "portMappings" : [
        {
          "containerPort" : var.port
        }
      ],
      "logConfiguration" : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-group" : "${aws_cloudwatch_log_group.hrforte-app-log-group.name}",
          "awslogs-region" : "${var.region}",
          "awslogs-stream-prefix" : "${aws_cloudwatch_log_stream.hrforte-app-log-stream.name}"
        }
      }
    }
  ])

  volume {
    name      = "hrforte-app"
    host_path = "/ecs/hrforte-app"
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [${var.availability_zones[0]}, ${var.availability_zones[1]}]"
  }
}
