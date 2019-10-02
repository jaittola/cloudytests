resource "aws_cloudwatch_log_group" "logs_fancyapp" {
    name = "logs-fancyapp"
    retention_in_days = 1
}
