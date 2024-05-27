# Created referring to:
# HashiCorp. 2023. 'Resource: aws_api_gateway_resource'.
# Retrieved from https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_resource
#
# HashiCorp. 2023. 'Resource: aws_api_gateway_method'.
# Retrieved from https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method
#
# HashiCorp. 2023. 'Resource: aws_api_gateway_integration'.
# Retrieved from https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_integration
#
# Amazon Web Services, Inc. 2023. 'Testing CORS'.
# Retrieved from https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-test-cors.html

# Resources
resource "aws_api_gateway_resource" "api" {
  rest_api_id = var.aws_api_gateway_rest_api.id
  parent_id = var.aws_api_gateway_rest_api.root_resource_id
  path_part = "api"
}

resource "aws_api_gateway_resource" "image" {
  rest_api_id = var.aws_api_gateway_rest_api.id
  parent_id = aws_api_gateway_resource.api.id
  path_part = "image"
}

resource "aws_api_gateway_resource" "images" {
  rest_api_id = var.aws_api_gateway_rest_api.id
  parent_id = aws_api_gateway_resource.api.id
  path_part = "images"
}

resource "aws_api_gateway_resource" "tags" {
  rest_api_id = var.aws_api_gateway_rest_api.id
  parent_id = aws_api_gateway_resource.api.id
  path_part = "tags"
}

# Methods
resource "aws_api_gateway_method" "root_method" {
  rest_api_id = var.aws_api_gateway_rest_api.id
  resource_id = var.aws_api_gateway_rest_api.root_resource_id
  http_method = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "image_method" {
  for_each = toset([
    "OPTIONS", "POST", "DELETE"
  ])
  rest_api_id = var.aws_api_gateway_rest_api.id
  resource_id = aws_api_gateway_resource.image.id
  http_method = each.key
  authorization = each.key == "OPTIONS" ? "NONE" : "COGNITO_USER_POOLS"
  authorizer_id = each.key == "OPTIONS" ? null : var.authorizer_id
}

resource "aws_api_gateway_method" "images_method" {
  for_each = toset([
    "OPTIONS", "POST"
  ])
  rest_api_id = var.aws_api_gateway_rest_api.id
  resource_id = aws_api_gateway_resource.images.id
  http_method = each.key
  authorization = each.key == "OPTIONS" ? "NONE" : "COGNITO_USER_POOLS"
  authorizer_id = each.key == "OPTIONS" ? null : var.authorizer_id
}

resource "aws_api_gateway_method" "tags_method" {
  for_each = toset([
    "OPTIONS", "POST"
  ])
  rest_api_id = var.aws_api_gateway_rest_api.id
  resource_id = aws_api_gateway_resource.tags.id
  http_method = each.key
  authorization = each.key == "OPTIONS" ? "NONE" : "COGNITO_USER_POOLS"
  authorizer_id = each.key == "OPTIONS" ? null : var.authorizer_id
}

# Integrations
resource "aws_api_gateway_integration" "root_integration" {
  rest_api_id = var.aws_api_gateway_rest_api.id
  resource_id = var.aws_api_gateway_rest_api.root_resource_id
  http_method = aws_api_gateway_method.root_method.http_method
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = var.lambda_external_options_root_invocation_arn
  credentials = "${var.lab_role_arn}"
}

resource "aws_api_gateway_integration" "image_integration" {
  for_each = {
    OPTIONS = var.lambda_external_options_image_invocation_arn
    POST = var.external_image_upload_invocation_arn,
    DELETE = var.external_image_deletion_invocation_arn
  }
  rest_api_id = var.aws_api_gateway_rest_api.id
  resource_id = aws_api_gateway_resource.image.id
  http_method = aws_api_gateway_method.image_method[each.key].http_method
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = each.value
  credentials = "${var.lab_role_arn}"
}

resource "aws_api_gateway_integration" "images_integration" {
  for_each = {
    OPTIONS = var.lambda_external_options_images_invocation_arn
    POST = var.external_image_search_invocation_arn
  }
  rest_api_id = var.aws_api_gateway_rest_api.id
  resource_id = aws_api_gateway_resource.images.id
  http_method = aws_api_gateway_method.images_method[each.key].http_method
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = each.value
  credentials = "${var.lab_role_arn}"
}

resource "aws_api_gateway_integration" "tags_integration" {
  for_each = {
    OPTIONS = var.lambda_external_options_tags_invocation_arn
    POST = var.external_image_tag_update_invocation_arn
  }
  rest_api_id = var.aws_api_gateway_rest_api.id
  resource_id = aws_api_gateway_resource.tags.id
  http_method = aws_api_gateway_method.tags_method[each.key].http_method
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = each.value
  credentials = "${var.lab_role_arn}"
}
