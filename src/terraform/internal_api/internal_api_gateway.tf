# Created referring to:
# HashiCorp. 2023. 'Resource: aws_api_gateway_rest_api'.
# Retrieved from https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_rest_api
#
# Amazon Web Services, Inc. 2023. 'Creating a private API in Amazon API Gateway'.
# Retrieved from https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-private-apis.html
#
# HashiCorp. 2023. 'local_file (Data Source)'.
# Retrieved from https://registry.terraform.io/providers/hashicorp/local/latest/docs/data-sources/file?product_intent=terraform
#
# Amazon Web Services, Inc. 2023. 'x-amazon-apigateway-integration object'.
# Retrieved from https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-swagger-extensions-integration.html
#
# Amazon Web Services, Inc. 2023. 'x-amazon-apigateway-integration object'
# Retrieved from https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-swagger-extensions-integration.html
#
# AWS OFFICIAL. 2023. 'How do I troubleshoot issues when connecting to an API Gateway private API endpoint?'.
# Retrieved from https://repost.aws/knowledge-center/api-gateway-private-endpoint-connection
#
# devguy. 2021. 'Answer to: Terraform Error: Error creating API Gateway Deployment: BadRequestException: No integration defined for method'.
# Retrieved from https://stackoverflow.com/a/66201601

resource "aws_api_gateway_rest_api" "cloud_snap_internal_api" {
  name = "${var.project_tag}-internal-api"
  description = "The internal API Gateway service, accessible only via an interface VPC endpoint"

  endpoint_configuration {
    types = [
      "PRIVATE"
    ]
    vpc_endpoint_ids = [
      aws_vpc_endpoint.internal_api_endpoint.id
    ]
  }

  tags = {
    Name = "${var.project_tag}-internal-api-gateway"
  }
}

module "body" {
  source = "./body"

  lab_role_arn = var.lab_role_arn
  aws_api_gateway_rest_api = aws_api_gateway_rest_api.cloud_snap_internal_api
  lambda_detection_invocation_arn = var.lambda_detection_invocation_arn
  lambda_delete_invocation_arn = var.lambda_delete_invocation_arn
  lambda_insert_invocation_arn = var.lambda_insert_invocation_arn
  lambda_update_invocation_arn = var.lambda_update_invocation_arn
  lambda_search_invocation_arn = var.lambda_search_invocation_arn
}

resource "aws_api_gateway_deployment" "cloud_snap_internal_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.cloud_snap_internal_api.id

  triggers = {
    redeployment = sha1(jsonencode([
      module.body
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [ 
    aws_api_gateway_rest_api_policy.internal_api_gateway_resource_policy,
    module.body
  ]
}

resource "aws_api_gateway_stage" "internal_api_gateway" {
  deployment_id = aws_api_gateway_deployment.cloud_snap_internal_api_deployment.id
  rest_api_id = aws_api_gateway_rest_api.cloud_snap_internal_api.id
  stage_name = "${var.project_tag}"
}
