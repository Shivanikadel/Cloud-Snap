# Created referring to:
# HashiCorp. n.d. 'Build Infrastructure'.
# Retrieved from https://developer.hashicorp.com/terraform/tutorials/aws-get-started/aws-build
#
# HashiCorp. n.d. 'Module Blocks'.
# Retrieved from https://developer.hashicorp.com/terraform/language/modules/syntax
#
# HashiCorp. 2023. 'AWS Provider - default_tags Configuration Block'.
# Retrieved from https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
#
# Moustakis, I. 2022. 'Terraform Output Values: Complete Guide & Examples'.
# Retrieved from https://spacelift.io/blog/terraform-output

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.67"
    }
    
    archive = {
      source = "hashicorp/archive"
      version = "~> 2.3.0"
    }
  }

  # Require a modern Terraform version.
  required_version = ">= 1.4.6"
}

provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      project = var.project_tag
    }
  }
}

module "network" {
  source = "./network"

  ssh_public_key = var.ssh_public_key
  project_tag = var.project_tag
}

module "lambda_functions" {
  source = "./lambda"

  lab_role_arn = var.lab_role_arn
  project_tag = var.project_tag
  bucket_suffix = var.code_bucket_suffix
  private_subnet_id = module.network.private_subnet_id
  internal_https_traffic_security_group_id = module.network.internal_https_traffic_security_group_id
}

module "internal_api" {
  source = "./internal_api"

  lab_role_arn = var.lab_role_arn
  project_tag = var.project_tag
  
  vpc_id = module.network.vpc_id
  vpc_cidr_block = module.network.vpc_cidr_block
  private_subnet_id = module.network.private_subnet_id
  lambda_detection_invocation_arn = module.lambda_functions.lambda_detection_invocation_arn
  lambda_delete_invocation_arn = module.lambda_functions.lambda_delete_invocation_arn
  lambda_insert_invocation_arn = module.lambda_functions.lambda_insert_invocation_arn
  lambda_update_invocation_arn = module.lambda_functions.lambda_update_invocation_arn
  lambda_search_invocation_arn = module.lambda_functions.lambda_search_invocation_arn
  internal_https_traffic_security_group_id = module.network.internal_https_traffic_security_group_id
}

module "dynamodb" {
  source = "./dynamodb"

  project_tag = var.project_tag
  table_deletion_protection = var.table_deletion_protection
}

module "external" {
  source = "./external"

  project_tag = var.project_tag
  bucket_suffix = var.code_bucket_suffix
  domain_suffix = var.code_bucket_suffix
}

module "external_api" {
  source = "./external_api"

  project_tag = var.project_tag
  lab_role_arn = var.lab_role_arn
  vpc_id = module.network.vpc_id
  cognito_user_pool_arn = module.external.cognito_user_pool_arn
  external_image_upload_invocation_arn = module.lambda_functions.lambda_external_image_upload_invocation_arn
  external_image_deletion_invocation_arn = module.lambda_functions.lambda_external_image_delete_invocation_arn
  external_image_tag_update_invocation_arn = module.lambda_functions.lambda_external_image_tag_update_invocation_arn
  external_image_search_invocation_arn = module.lambda_functions.lambda_external_image_search_invocation_arn
  lambda_external_options_image_invocation_arn = module.lambda_functions.lambda_external_options_image_invocation_arn
  lambda_external_options_images_invocation_arn = module.lambda_functions.lambda_external_options_images_invocation_arn
  lambda_external_options_tags_invocation_arn = module.lambda_functions.lambda_external_options_tags_invocation_arn
  lambda_external_options_root_invocation_arn = module.lambda_functions.lambda_external_options_root_invocation_arn
}

module "website" {
  source = "./website"

  bucket_suffix = var.domain_suffix
}
