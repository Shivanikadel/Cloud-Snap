# Input variables for the Lambda archives

variable "name" {
  type = string
  description = "The name of the Lambda function"
}

variable "lab_role_arn" {
  type = string
  description = "The Amazon Resource Name for the LabRole in AWS Academy"
}

variable "source_dir" {
  type = string
  description = "The source directory for the Lambda code"
}

variable "runtime" {
  type = string
  description = "The runtime of the Lambda function"
}

variable "handler" {
  type = string
  description = "The handler of the Lambda function"
}

variable "s3_bucket" {
  type = string
  description = "The S3 bucket for storing Lambda code"
}

variable "memory_allocation" {
  type = number
  description = "The memory allocation for the Lambda function in MB"
  default = 128
}

variable "timeout" {
  type = number
  description = "The maximum running time allowed for the function in seconds"
  default = 3
}

variable "vpc_config" {
  type = object({
    security_group_ids = list(string)
    subnet_ids = list(string)
  })
  description = "The vpc_config for the Lambda function"
  default = {
    security_group_ids = []
    subnet_ids = []
  }
}
