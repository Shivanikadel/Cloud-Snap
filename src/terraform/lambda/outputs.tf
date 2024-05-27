# Created referring to:
# HashiCorp. n.d. 'Output Values'.
# Retrieved from https://developer.hashicorp.com/terraform/language/values/outputs

output "lambda_detection_invocation_arn" {
  description = "The invocation ARN of the internal detection AWS Lambda function"
  value = module.lambda_functions["detection"].lambda_invocation_arn
}

output "lambda_delete_invocation_arn" {
  description = "The invocation ARN of the internal delete AWS Lambda function"
  value = module.lambda_functions["delete"].lambda_invocation_arn
}

output "lambda_insert_invocation_arn" {
  description = "The invocation ARN of the internal insert AWS Lambda function"
  value = module.lambda_functions["insert"].lambda_invocation_arn
}

output "lambda_update_invocation_arn" {
  description = "The invocation ARN of the internal update AWS Lambda function"
  value = module.lambda_functions["update"].lambda_invocation_arn
}

output "lambda_search_invocation_arn" {
  description = "The invocation ARN of the internal search AWS Lambda function"
  value = module.lambda_functions["search"].lambda_invocation_arn
}

output "lambda_external_options_image_invocation_arn" {
  description = "The OPTIONS for /api/image"
  value = module.lambda_functions["external_image_options"].lambda_invocation_arn
}

output "lambda_external_options_images_invocation_arn" {
  description = "The OPTIONS for /api/images"
  value = module.lambda_functions["external_images_options"].lambda_invocation_arn
}

output "lambda_external_options_tags_invocation_arn" {
  description = "The OPTIONS for /api/tags"
  value = module.lambda_functions["external_tags_options"].lambda_invocation_arn
}

output "lambda_external_options_root_invocation_arn" {
  description = "The OPTIONS for /"
  value = module.lambda_functions["external_root_options"].lambda_invocation_arn
}

output "lambda_external_image_upload_invocation_arn" {
  description = "The invocation ARN of the external image upload AWS Lambda function"
  value = module.lambda_functions["external_image_upload"].lambda_invocation_arn
}

output "lambda_external_image_tag_update_invocation_arn" {
  description = "The invocation ARN of the external image tag update AWS Lambda function"
  value = module.lambda_functions["external_image_tag_update"].lambda_invocation_arn
}

output "lambda_external_image_delete_invocation_arn" {
  description = "The invocation ARN of the external image delete AWS Lambda function"
  value = module.lambda_functions["external_image_delete"].lambda_invocation_arn
}

output "lambda_external_image_search_invocation_arn" {
  description = "The invocation ARN of the external image search AWS Lambda function"
  value = module.lambda_functions["external_image_search"].lambda_invocation_arn
}
