resource "aws_sns_topic" "cost_alerts" {
  name = "cost_alerts"
  // SNS topic for cost alerts
} 

resource "aws_sns_topic_subscription" "cost_alerts_email" {
    topic_arn = aws_sns_topic.cost_alerts.arn
    protocol  = "email"
    endpoint  = var.alert_email
    // Subscription to the SNS topic for email alerts
} 