# IAM ROLE [ecs-role]: Initialize role and configure principal service
resource "aws_iam_role" "ecs-role" {
  name               = "ecs_host_role_datalake_v2_${var.stage}"
  assume_role_policy = file("policies/ecs-role.json")
}

# IAM ROLE POLICY [ecs-instance-role-policy]: Initialize policy and configure actions, resources and apply to [ecs-role]
resource "aws_iam_role_policy" "ecs-instance-role-policy" {
  name   = "ecs_instance_role_policy"
  policy = file("policies/ecs-instance-role-policy.json")
  role   = aws_iam_role.ecs-role.id
}