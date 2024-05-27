# Created referring to:
# Araújo, G. 2020. 'Exploring Cognito User Pools'.
# Retrieved from https://medium.com/@gabriel-araujo/exploring-cognito-user-pools-2d8a60467b71
#
# HashiCorp. 2023. 'Resource: aws_cognito_user_pool'.
# Retrieved from https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool
#
# Araújo, G. 2020. 'medium/cognito_user_pool.tf'.
# Retrieved from https://github.com/GabrielAraujo/medium/blob/exploring_cognito_user_pools/cognito_user_pool.tf
#
# HashiCorp. 2023. 'Resource: aws_cognito_user_pool_client'.
# Retrieved from https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool_client

resource "aws_cognito_user_pool" "cloud_snap_user_pool" {
  name = "${var.project_tag}-user-pool"

  username_attributes = [
    "email"
  ]

  auto_verified_attributes = [
    "email"
  ]

  password_policy {
    minimum_length = 8
    require_lowercase = true
    require_uppercase = true
    require_numbers = true
    require_symbols = false
  }

  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
    email_subject = "FIT5225 Group 44 - ${var.project_tag} - Account Confirmation"
    email_message = "Your confirmation code for your FIT5225 Group 44 - ${var.project_tag} account is {####}"
  }

  email_configuration {
    email_sending_account = "COGNITO_DEFAULT"
  }
  
  mfa_configuration = "OFF"

  schema {
    name = "family_name"
    attribute_data_type = "String"
    required = true
  }
  
  schema {
    name = "given_name"
    attribute_data_type = "String"
    required = true
  }
  
  schema {
    name = "preferred_username"
    attribute_data_type = "String"
    required = true
  }

  // email attribute schema configuartion
  schema {
    attribute_data_type = "String"
    developer_only_attribute = false
    mutable = false
    name = "email"

    string_attribute_constraints {
      min_length = 1
      max_length = 256
    }
  }

  // username attribute schema configuration(Need to check on this)
  schema {
    attribute_data_type = "String"
    developer_only_attribute = false
    mutable = false
    name = "username"

    string_attribute_constraints {
      min_length = 8
      max_length = 64
    }
  }
}

resource "aws_cognito_user_pool_client" "cloud_snap_client" {
  name = "${var.project_tag}-client"

  user_pool_id = aws_cognito_user_pool.cloud_snap_user_pool.id
  
  allowed_oauth_flows = [
    "code", "implicit"
  ]
  allowed_oauth_scopes = [
    "openid", "email", "profile"
  ]
  
  # Ideally, we would not hardcode these...
  callback_urls = [
    # TODO: Front-end S3 buckets URLs (this part of client-side code needs to be deployed to S3 first)
    # "http://s3-image-detection-${var.bucket_suffix}-hosting.s3-website-us-east-1.amazonaws.com/"
    "https://localhost:443/"
  ]
  
  logout_urls = [
    # TODO: Front-end S3 buckets URLs (this part of client-side code needs to be deployed to S3 first)
    # "http://s3-image-detection-${var.bucket_suffix}-hosting.s3-website-us-east-1.amazonaws.com/"
    "https://localhost:443/"
  ]
  
  refresh_token_validity = 30
  
  generate_secret = false
  prevent_user_existence_errors = "ENABLED"
  explicit_auth_flows = [
    "ALLOW_CUSTOM_AUTH",
    "ALLOW_USER_SRP_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH"
  ]
  
}

# TODO: It looks like we need to create the hosted UI manually in the management console?
resource "aws_cognito_user_pool_domain" "cloud_snap_cognito_domain" {
  domain = "${var.project_tag}-${var.domain_suffix}"
  user_pool_id = aws_cognito_user_pool.cloud_snap_user_pool.id
}
