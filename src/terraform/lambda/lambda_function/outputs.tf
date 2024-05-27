# Created referring to:
# HashiCorp. n.d. 'Output Values'.
# Retrieved from https://developer.hashicorp.com/terraform/language/values/outputs

output "lambda_invocation_arn" {
  description = "The invocation ARN of the AWS Lambda"
  value = aws_lambda_function.lambda_function.invoke_arn
}
