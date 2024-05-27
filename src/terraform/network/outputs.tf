# Created referring to:
# HashiCorp. n.d. 'Output Values'.
# Retrieved from https://developer.hashicorp.com/terraform/language/values/outputs

output "vpc_id" {
  description = "The ID of the VPC in this project"
  value = aws_vpc.cloud_snap_vpc.id
}

output "vpc_cidr_block" {
  description = "The CIDR block for the VPC in this project"
  value = aws_vpc.cloud_snap_vpc.cidr_block
}

output "private_subnet_id" {
  description = "The ID of the private subnet in this project"
  value = aws_subnet.cloud_snap_private_subnet.id
}

output "public_subnet_id" {
  description = "The ID of the public subnet in this project"
  value = aws_subnet.cloud_snap_public_subnet.id
}

output "internal_https_traffic_security_group_id" {
  description = "The ID of the security group permitting internal HTTPS traffic"
  value = aws_security_group.internal_https_traffic_security_group.id
}
