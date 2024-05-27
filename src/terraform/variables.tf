# Input variables for the Terraform project

variable "lab_role_arn" {
  type = string
  description = "The Amazon Resource Name for the LabRole in AWS Academy"
}

variable "ssh_public_key" {
  type = string
  description = "Local developer's public key for use with SSH when accessing the bastion host"
}

variable "code_bucket_suffix" {
  type = string
  description = "A random suffix for the S3 bucket name to ensure that it is unique"
}

variable "domain_suffix" {
  type = string
  description = "A random suffix for the Cognito domain name to ensure that it is unique"
}

variable "project_tag" {
  type = string
  description = "The value of the project tag, with which resources contained in this assignment are tagged by default"
  default = "cloud-snap"
}

variable "table_deletion_protection" {
  type = bool
  description = "Prevent deletion of the DynamoDB table (this would likely require your manual intervention in order to run terraform destroy)"
  default = false
}
