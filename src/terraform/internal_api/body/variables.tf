# Created referring to:
# HashiCorp. n.d. 'Input Variables'.
# Retrieved from https://developer.hashicorp.com/terraform/language/values/variables

# Input variables for AWS API Gateway body resources and methods

variable "lab_role_arn" {
  type = string
  description = "The Amazon Resource Name for the LabRole in AWS Academy"
}

variable "aws_api_gateway_rest_api" {
  type = object({
    id = string
    root_resource_id = string
  })
  description = "The API Gateway object"
}

variable "lambda_detection_invocation_arn" {
  type = string
  description = "The ARN of the internal detection AWS Lambda function"
}

variable "lambda_delete_invocation_arn" {
  type = string
  description = "The invocation ARN of the internal delete AWS Lambda function"
}

variable "lambda_insert_invocation_arn" {
  type = string
  description = "The invocation ARN of the internal insert AWS Lambda function"
}

variable "lambda_update_invocation_arn" {
  type = string
  description = "The invocation ARN of the internal update AWS Lambda function"
}

variable "lambda_search_invocation_arn" {
  type = string
  description = "The invocation ARN of the internal search AWS Lambda function"
}
