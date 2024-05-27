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

variable "authorizer_id" {
  type = string
  description = "The authorizer ID for each method"
}

