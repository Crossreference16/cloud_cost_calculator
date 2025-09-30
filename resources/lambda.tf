resource "aws_lambda_function" "weekly_report" {
  function_name = "weekly_cost_report"
  runtime = "python3.11"
  handler = "lambda_function.lambda_handler"
  filename = "lambda/function.zip"
  role = aws_iam_role.lambda_exec.arn
  // Lambda function for weekly cost reporting
}

resource "aws_cloudwatch_event_rule" "weekly_schedule" {
    name                = "weekly_cost_check"
    schedule_expression = "rate(7 days)"
    // cloudWatch event rule to trigger the Lambda function weekly
} 


resource "aws_cloudwatch_event_target" "lambda_target" {
    rule = aws_cloudwatch_event_rule.weekly_schedule.name
    target_id = "weekly_lambda"
    arn = aws_lambda_function.weekly_report.arn
    //  links the above (2nd resource from the top) CloudWatch Event rule to the above (1st resource at the top) Lambda function
}

resource "aws_lambda_permission" "allow_cloudwatch" {
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.weekly_report.function_name
    principal = "events.amazonaws.com"
    source_arn = aws_cloudwatch_event_rule.weekly_schedule.arn
    // Permission for CloudWatch to invoke the Lambda function
} 



resource "aws_iam_role" "lambda_exec" {
    name = "lambda_exec_role" // IAM role for Lambda execution
    assume_role_policy = jsonencode({
        Version = "2012-10-17" 
        Statement = [
            {
                Action = "sts:AssumeRole"
                Principal = {
                    Service = "lambda.amazonaws.com"
                }
                Effect = "Allow"
                Sid = ""
            }// this policy allows the Lambda service to assume this role
        ]
    })// this whole block is the trust policy
}

resource "aws_iam_role_policy_attachment" "lambda_exec_attach" {
    role = aws_iam_role.lambda_exec.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
    // this attachment gives the Lambda function basic execution permissions (like writing logs to CloudWatch)
  
}