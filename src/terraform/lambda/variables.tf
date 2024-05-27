# Input variables for AWS Lambda functions

variable "lab_role_arn" {
  type = string
  description = "The Amazon Resource Name for the LabRole in AWS Academy"
}

variable "project_tag" {
  type = string
  description = "The value of the project tag, with which resources contained in this assignment are tagged by default"
}

variable "bucket_suffix" {
  type = string
  description = "A random suffix for the S3 bucket name to ensure that it is unique"
}

variable "private_subnet_id" {
  type = string
  description = "The ID of the private subnet in this project"
}

variable "internal_https_traffic_security_group_id" {
  type = string
  description = "The ID of the security group permitting internal HTTPS traffic"
}
