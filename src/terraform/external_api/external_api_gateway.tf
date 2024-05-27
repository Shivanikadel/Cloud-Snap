# Created referring to:
# HashiCorp. 2023. 'Resource: aws_api_gateway_rest_api'.
# Retrieved from https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_rest_api
#
# HashiCorp. 2023. 'Resource: aws_api_gateway_authorizer'.
# Retrieved from https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_authorizer 

resource "aws_api_gateway_rest_api" "cloud_snap_external_api" {
  name        = "${var.project_tag}-external-api"
  description = "The external API Gateway service, accessible to users"
  tags = {
    Name = "${var.project_tag}-external-api-gateway"
  }
}

module "body" {
  source = "./body"

  lab_role_arn = var.lab_role_arn
  aws_api_gateway_rest_api = aws_api_gateway_rest_api.cloud_snap_external_api
  external_image_upload_invocation_arn = var.external_image_upload_invocation_arn
  external_image_deletion_invocation_arn = var.external_image_deletion_invocation_arn
  external_image_tag_update_invocation_arn = var.external_image_tag_update_invocation_arn
  external_image_search_invocation_arn = var.external_image_search_invocation_arn
  lambda_external_options_image_invocation_arn = var.lambda_external_options_image_invocation_arn
  lambda_external_options_images_invocation_arn = var.lambda_external_options_images_invocation_arn
  lambda_external_options_tags_invocation_arn = var.lambda_external_options_tags_invocation_arn
  lambda_external_options_root_invocation_arn = var.lambda_external_options_root_invocation_arn
  authorizer_id = aws_api_gateway_authorizer.cloud_snap_gateway_authorizer.id
}

resource "aws_api_gateway_deployment" "cloud_snap_external_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.cloud_snap_external_api.id

  triggers = {
    redeployment = sha1(jsonencode([
      module.body
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [ 
    aws_api_gateway_rest_api_policy.external_api_gateway_resource_policy,
    module.body
  ]
}

resource "aws_api_gateway_authorizer" "cloud_snap_gateway_authorizer" {
  name = "${var.project_tag}_authorizer"
  rest_api_id = aws_api_gateway_rest_api.cloud_snap_external_api.id
  type = "COGNITO_USER_POOLS"
  identity_source = "method.request.header.Authorization"
  authorizer_credentials = var.lab_role_arn
  authorizer_result_ttl_in_seconds = 300
  provider_arns = [
    var.cognito_user_pool_arn
  ]
}

resource "aws_api_gateway_stage" "external_api_gateway" {
  deployment_id = aws_api_gateway_deployment.cloud_snap_external_api_deployment.id
  rest_api_id = aws_api_gateway_rest_api.cloud_snap_external_api.id
  stage_name =  "${var.project_tag}"
}
