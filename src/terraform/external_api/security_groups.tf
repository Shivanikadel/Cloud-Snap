# HashiCorp. 2023. 'Resource: aws_security_group'.
# Retrieved from https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group

resource "aws_security_group" "external_api_security_group" {
  name = "external_api_security_group"
  description = "Permits TCP (HTTPs) traffic to reach the external API Gateway endpoint"
  vpc_id = var.vpc_id

  ingress {
    description = "HTTPS from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [ 
      "0.0.0.0/0"
    ]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [ 
      "0.0.0.0/0"
    ]
  }
}
