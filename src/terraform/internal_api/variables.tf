# Input variables for AWS API Gateway resources

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

variable "vpc_cidr_block" {
  type = string
  description = "The CIDR block for the VPC in this project"
}

variable "private_subnet_id" {
  type = string
  description = "The ID of the private subnet in this project"
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

variable "internal_https_traffic_security_group_id" {
  type = string
  description = "The ID of the security group permitting internal HTTPS traffic"
}
