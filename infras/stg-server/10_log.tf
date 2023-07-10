# LOG GROUP [datalake-app-log-group]: Initialize log group
resource "aws_cloudwatch_log_group" "datalake-app-log-group" {
  name = "${var.project_name}-log-group"
}

# LOG STREAM [datalake-app-log-stream]: Initialize log stream
resource "aws_cloudwatch_log_stream" "datalake-app-log-stream" {
  name           = "${var.project_name}-log-stream"
  log_group_name = aws_cloudwatch_log_group.datalake-app-log-group.name
}


