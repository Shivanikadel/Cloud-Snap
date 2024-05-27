# Created referring to:
# HashiCorp. 2023. 'Resource: aws_vpc'.
# Retrieved from https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
#
# HashiCorp. 2023. 'Resource: aws_subnet'.
# Retrieved from https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
#
#   > NOTE: The documentation calls-out the potential for long deletion times when 
#           destroying subnets associated with AWS Lambda resources.
#
# HashiCorp. 2023. 'Resource: aws_route_table'.
# Retrieved from https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
#
# HashiCorp. 2023. 'Resource: aws_internet_gateway'.
# Retrieved from https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway
#
# HashiCorp. 2023. 'Resource: aws_route_table_association'.
# Retrieved from https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association
#
# HashiCorp. 2023. 'Resource: aws_nat_gateway'.
# Retrieved from https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway
#
# HashiCorp. 2023. 'Resource: aws_eip'.
# Retrieved from https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip

resource "aws_vpc" "cloud_snap_vpc" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_tag}-vpc"
  }
}

resource "aws_subnet" "cloud_snap_private_subnet" {
  vpc_id = aws_vpc.cloud_snap_vpc.id

  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "${var.project_tag}-private-subnet"
  }
}

resource "aws_subnet" "cloud_snap_public_subnet" {
  vpc_id = aws_vpc.cloud_snap_vpc.id

  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_tag}-public-subnet"
  }
}

resource "aws_internet_gateway" "cloud_snap_internet_gateway" {
  vpc_id = aws_vpc.cloud_snap_vpc.id
}

resource "aws_eip" "elastic_ip" {
  depends_on = [
    aws_internet_gateway.cloud_snap_internet_gateway
  ]
}

resource "aws_nat_gateway" "cloud_snap_nat_gateway" {
  allocation_id = aws_eip.elastic_ip.id
  subnet_id = aws_subnet.cloud_snap_public_subnet.id

  tags = {
    Name = "${var.project_tag}-nat-gateway"
  }

  depends_on = [
    aws_internet_gateway.cloud_snap_internet_gateway
  ]
}

resource "aws_route_table_association" "public_subnet_route_table_association" {
  subnet_id = aws_subnet.cloud_snap_public_subnet.id
  route_table_id = aws_route_table.cloud_snap_public_subnet_route_table.id
}

resource "aws_route_table_association" "private_subnet_route_table_association" {
  subnet_id = aws_subnet.cloud_snap_private_subnet.id
  route_table_id = aws_route_table.cloud_snap_private_subnet_route_table.id
}

resource "aws_route_table" "cloud_snap_public_subnet_route_table" {
  vpc_id = aws_vpc.cloud_snap_vpc.id

  # aws_subnet.cloud_snap_public_subnet.cidr_block mapping to "local"
  # is implicit (defined by Terraform).

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cloud_snap_internet_gateway.id
  }

  tags = {
    Name = "${var.project_tag}-public-subnet-route-table"
  }
}

resource "aws_route_table" "cloud_snap_private_subnet_route_table" {
  vpc_id = aws_vpc.cloud_snap_vpc.id

  # aws_subnet.cloud_snap_private_subnet.cidr_block mapping to "local"
  # is implicit (defined by Terraform).

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.cloud_snap_nat_gateway.id
  }

  tags = {
    Name = "${var.project_tag}-private-subnet-route-table"
  }
}
