output "aws_sns_topic_arn" {
  value = aws_sns_topic.cost_alerts.arn
  
}

output "s3_dashboard_url" {
  value = aws_s3_bucket.dashboard.website_endpoint
  
}