# Created referring to:
# HashiCorp. 2023. 'Resource: aws_api_gateway_resource'.
# Retrieved from https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_resource
#
# HashiCorp. 2023. 'Resource: aws_api_gateway_method'.
# Retrieved from https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method
#
# HashiCorp. 2023. 'Resource: aws_api_gateway_integration'.
# Retrieved from https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_integration

# Resources
resource "aws_api_gateway_resource" "api" {
  rest_api_id = var.aws_api_gateway_rest_api.id
  parent_id = var.aws_api_gateway_rest_api.root_resource_id
  path_part = "api"
}

resource "aws_api_gateway_resource" "iod" {
  rest_api_id = var.aws_api_gateway_rest_api.id
  parent_id = aws_api_gateway_resource.api.id
  path_part = "iod"
}

resource "aws_api_gateway_resource" "data" {
  rest_api_id = var.aws_api_gateway_rest_api.id
  parent_id = aws_api_gateway_resource.api.id
  path_part = "data"
}

# Methods
resource "aws_api_gateway_method" "iod_method" {
  rest_api_id = var.aws_api_gateway_rest_api.id
  resource_id = aws_api_gateway_resource.iod.id
  http_method = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "data_methods" {
  for_each = toset([
    "GET", "PUT", "POST", "DELETE"
  ])
  rest_api_id = var.aws_api_gateway_rest_api.id
  resource_id = aws_api_gateway_resource.data.id
  http_method = each.key
  authorization = "NONE"
}

# Integrations
resource "aws_api_gateway_integration" "iod_integration" {
  rest_api_id = var.aws_api_gateway_rest_api.id
  resource_id = aws_api_gateway_resource.iod.id
  http_method = aws_api_gateway_method.iod_method.http_method
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = var.lambda_detection_invocation_arn
  credentials = "${var.lab_role_arn}"
}

resource "aws_api_gateway_integration" "data_integration" {
  for_each = {
    GET = var.lambda_search_invocation_arn,
    PUT = var.lambda_update_invocation_arn,
    POST = var.lambda_insert_invocation_arn,
    DELETE = var.lambda_delete_invocation_arn
  }
  rest_api_id = var.aws_api_gateway_rest_api.id
  resource_id = aws_api_gateway_resource.data.id
  http_method = aws_api_gateway_method.data_methods[each.key].http_method
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = each.value
  credentials = "${var.lab_role_arn}"
}
