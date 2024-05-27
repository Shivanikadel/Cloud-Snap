# Input variables for AWS network resources

variable "ssh_public_key" {
  type = string
  description = "Local developer's public key for use with SSH when accessing the bastion host"
}

variable "project_tag" {
  type = string
  description = "The value of the project tag, with which resources contained in this assignment are tagged by default"
}
