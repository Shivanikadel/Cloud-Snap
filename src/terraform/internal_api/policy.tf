# Created referring to:
# HashiCorp. 2023. 'Resource: aws_api_gateway_rest_api_policy'.
# Retrieved from https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_rest_api_policy
#
# HashiCorp. 2023. 'Data Source: aws_iam_policy_document'.
# Retrieved from https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document
#
# Amazon Web Services, Inc. 2023. 'AWS JSON policy elements: Principal'.
# Retrieved from https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_elements_principal.html
#
# Amazon Web Services, Inc. 2023. 'IAM JSON policy elements: Condition'.
# Retrieved from https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_elements_condition.html

resource "aws_api_gateway_rest_api_policy" "internal_api_gateway_resource_policy" {
  rest_api_id = aws_api_gateway_rest_api.cloud_snap_internal_api.id
  policy = data.aws_iam_policy_document.internal_api_gateway_access_document.json
}

data "aws_iam_policy_document" "internal_api_gateway_access_document" {
  statement {
    effect = "Allow"

    principals {
      type = "AWS"
      identifiers = [
        "${var.lab_role_arn}"
      ]
    }

    resources = [
      "${aws_api_gateway_rest_api.cloud_snap_internal_api.execution_arn}/*"
    ]

    actions = [
      "execute-api:Invoke"
    ]
  }

  statement {
    effect = "Allow"

    principals {
      type = "*"
      identifiers = [
        "*"
      ]
    }

    resources = [
      "${aws_api_gateway_rest_api.cloud_snap_internal_api.execution_arn}/*"
    ]

    actions = [
      "execute-api:Invoke"
    ]

    condition {
      variable = "aws:SourceVpce"
      test = "StringEquals"
      values = [
        aws_vpc_endpoint.internal_api_endpoint.id
      ]
    }

    condition {
      variable = "aws:SourceVpc"
      test = "StringEquals"
      values = [
        var.vpc_id
      ]
    }
  }
}
