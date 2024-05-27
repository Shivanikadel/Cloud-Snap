# Created referring to:
# HashiCorp. 2023. 'Resource: aws_vpc_endpoint'.
# Retrieved from https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint
#
# HashiCorp. 2023. 'Data Source: aws_region'.
# Retrieved from https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region
#
# Amazon Web Services, Inc. 2023. 'How to invoke a private API'.
# Retrieved from https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-private-api-test-invoke-url.html

data "aws_vpc_endpoint_service" "api" {
  service = "execute-api"
}

resource "aws_vpc_endpoint" "internal_api_endpoint" {
  vpc_id = var.vpc_id
  subnet_ids = [
    var.private_subnet_id,
  ]
  vpc_endpoint_type = "Interface"
  service_name = data.aws_vpc_endpoint_service.api.service_name
  security_group_ids = [
    var.internal_https_traffic_security_group_id
  ]
  private_dns_enabled = true

  tags = {
    Name = "${var.project_tag}-internal-api-endpoint"
  }
}
