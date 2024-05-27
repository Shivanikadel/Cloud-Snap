# Created referring to:
# HashiCorp. 2023. 'Resource: aws_security_group'.
# Retrieved from https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
#
# HashiCorp. 2023. 'Resource: aws_security_group_rule'.
# Retrieved from https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule

resource "aws_security_group" "internal_https_traffic_security_group" {
  name = "internal_https_traffic_security_group"
  description = "Permits TCP (HTTPs) traffic within the VPC"
  vpc_id = aws_vpc.cloud_snap_vpc.id

  ingress {
    description = "HTTPs from ${var.project_tag} VPC"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [
      aws_vpc.cloud_snap_vpc.cidr_block
    ]
  }

  egress {
    description = "HTTPs to anywhere"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
}

resource "aws_security_group" "bastion_security_group" {
  name = "bastion_security_group"
  description = "Permits TCP traffic on port 22 (e.g. to permit SSH connections) and internal HTTPS traffic"
  vpc_id = aws_vpc.cloud_snap_vpc.id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "allow_ssh_ingress" {
  security_group_id = aws_security_group.bastion_security_group.id
  type = "ingress"
  description = "SSH from anywhere"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = [
    "0.0.0.0/0"
  ]
}

resource "aws_security_group_rule" "allow_ssh_egress" {
  security_group_id = aws_security_group.bastion_security_group.id
  type = "egress"
  description = "SSH to anywhere"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = [
    "0.0.0.0/0"
  ]
}

resource "aws_security_group_rule" "allow_https_ingress" {
  security_group_id = aws_security_group.bastion_security_group.id
  type = "ingress"
  description = "HTTPs from ${var.project_tag} VPC"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  cidr_blocks = [
    aws_vpc.cloud_snap_vpc.cidr_block
  ]
}

resource "aws_security_group_rule" "allow_https_egress" {
  security_group_id = aws_security_group.bastion_security_group.id
  type = "egress"
  description = "HTTPs to ${var.project_tag} VPC"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  cidr_blocks = [
    aws_vpc.cloud_snap_vpc.cidr_block
  ]
}
