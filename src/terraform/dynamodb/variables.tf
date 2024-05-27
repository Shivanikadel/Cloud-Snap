# Input variables for DynamoDB

variable "project_tag" {
  type = string
  description = "The value of the project tag, with which resources contained in this assignment are tagged by default"
}

variable "table_deletion_protection" {
  type = bool
  description = "Prevent deletion of the DynamoDB table (this would likely require your manual intervention in order to run terraform destroy)"
}
