# Input variables for external resources

variable "project_tag" {
  type = string
  description = "The value of the project tag, with which resources contained in this assignment are tagged by default"
  default = "cloud-snap"
}

variable "bucket_suffix" {
  type = string
  description = "A random suffix for the S3 bucket name to ensure that it is unique"
}

variable "domain_suffix" {
  type = string
  description = "A random suffix for the Cognito domain name to ensure that it is unique"
}
