# Variables for AWS API Gateway resources(If Possible add form external_api_gateway.tf)

variable "lab_role_arn" {
  type = string
  description = "The Amazon Resource Name for the LabRole in AWS Academy"
}

variable "project_tag" {
  type = string
  description = "The value of the project tag, with which resources contained in this assignment are tagged by default"
}

variable "vpc_id" {
  type = string
  description = "The ID of the VPC in this project"
}

variable "external_image_upload_invocation_arn" {
  type = string
  description = "The ARN of the image upload AWS Lambda function"
}

variable "external_image_deletion_invocation_arn" {
  type = string
  description = "The ARN of the image deletion AWS Lambda function"
}

variable "external_image_tag_update_invocation_arn" {
  type = string
  description = "The ARN of the image tag update AWS Lambda function"
}

variable "external_image_search_invocation_arn" {
  type = string
  description = "The ARN of the image search AWS Lambda function"
}

variable "lambda_external_options_image_invocation_arn" {
  type = string
  description = "The OPTIONS for /api/image"
}

variable "lambda_external_options_images_invocation_arn" {
  type = string
  description = "The OPTIONS for /api/images"
}

variable "lambda_external_options_tags_invocation_arn" {
  type = string
  description = "The OPTIONS for /api/tags"
}

variable "lambda_external_options_root_invocation_arn" {
  type = string
  description = "The OPTIONS for /"
}

variable "cognito_user_pool_arn" {
  type = string
  description = "The ARN of the Cognito user pool for authorisation"
}
