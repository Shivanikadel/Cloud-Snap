
output "cognito_user_pool_arn" {
  description = "The ARN of the Cognito user pool for authorisation"
  value = aws_cognito_user_pool.cloud_snap_user_pool.arn
}

