# Created referring to:
# HashiCorp. 2023. 'Resource: aws_instance'.
# Retrieved from https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance

resource "aws_instance" "bastion" {
  ami = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
  key_name = aws_key_pair.bastion_key_pair.key_name

  network_interface {
    network_interface_id = aws_network_interface.bastion_eni.id
    device_index = 0
  }

  tags = {
    Name = "${var.project_tag}-bastion-host"
  }
}

resource "aws_network_interface" "bastion_eni" {
  subnet_id = aws_subnet.cloud_snap_public_subnet.id
  security_groups = [
    aws_security_group.bastion_security_group.id
  ]
}

resource "aws_key_pair" "bastion_key_pair" {
  key_name = "bastion_key_pair"
  public_key = var.ssh_public_key
}
