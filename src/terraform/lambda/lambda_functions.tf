# Created referring to:
# HashiCorp. 2023. 'Resource: aws_lambda_function'.
# Retrieved from https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function
#
# King, M. 2023. 'How to Deploy AWS Lambda Function (one or multiple subfiles)
# with Terraform - Step-by-Step Guide'.
# Retrieved from https://medium.com/@neonforge/how-to-deploy-aws-lambda-function-one-or-multiple-subfiles-with-terraform-step-by-step-guide-8bff3d34d95b
#
# HashiCorp. 2023. 'archive_file (Data Source)'.
# Retrieved from https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file
#
# HashiCorp. n.d. 'The for_each Meta-Argument'.
# Retrieved from https://developer.hashicorp.com/terraform/language/meta-arguments/for_each

locals {
  function_data = tomap({
    detection = {
      path = "main/python/detection"
      runtime = "python3.10"
      handler = "object_detection.handler"
      memory_allocation = 512
      timeout = 30
      attach_to_vpc = false
    }
    delete = {
      path = "main/python/delete"
      runtime = "python3.10"
      handler = "delete_image.lambda_handler"
      memory_allocation = 512
      timeout = 30
      attach_to_vpc = false
    }
    insert = {
      path = "main/python/insert"
      runtime = "python3.10"
      handler = "insert_image.lambda_handler"
      memory_allocation = 512
      timeout = 30
      attach_to_vpc = false
    }
    update = {
      path = "main/python/update"
      runtime = "python3.10"
      handler = "update_image.lambda_handler"
      memory_allocation = 512
      timeout = 30
      attach_to_vpc = false
    }
    search = {
      path = "main/python/search"
      runtime = "python3.10"
      handler = "search_image.lambda_handler"
      memory_allocation = 512
      timeout = 30
      attach_to_vpc = false
    }
    external_image_options = {
      path = "main/python/external/options_image"
      runtime = "python3.10"
      handler = "options.handler"
    }
    external_images_options = {
      path = "main/python/external/options_images"
      runtime = "python3.10"
      handler = "options.handler"
    }
    external_tags_options = {
      path = "main/python/external/options_tags"
      runtime = "python3.10"
      handler = "options.handler"
    }
    external_root_options = {
      path = "main/python/external/options_root"
      runtime = "python3.10"
      handler = "options.handler"
    }
    external_image_upload = {
      path = "main/python/external/image_upload"
      runtime = "python3.10"
      handler = "image_upload.handler"
      memory_allocation = 512
      timeout = 30
      attach_to_vpc = true
    }
    external_image_tag_update = {
      path = "main/python/external/image_tag_update"
      runtime = "python3.10"
      handler = "image_tag_update.handler"
      memory_allocation = 512
      timeout = 30
      attach_to_vpc = true
    }
    external_image_delete = {
      path = "main/python/external/image_delete"
      runtime = "python3.10"
      handler = "image_delete.handler"
      memory_allocation = 512
      timeout = 30
      attach_to_vpc = true
    }
    external_image_search = {
      path = "main/python/external/image_search"
      runtime = "python3.10"
      handler = "image_search.handler"
      memory_allocation = 512
      timeout = 30
      attach_to_vpc = true
    }
  })
}

module "lambda_functions" {
  for_each = local.function_data

  source = "./lambda_function"

  name = each.key
  lab_role_arn = var.lab_role_arn
  source_dir = each.value.path
  runtime = each.value.runtime
  handler = each.value.handler
  s3_bucket = aws_s3_bucket.code_bucket.bucket
  memory_allocation = try(each.value.memory_allocation, 128)
  timeout = try(each.value.timeout, 3)
  vpc_config = try(each.value.attach_to_vpc, false) ? {
    security_group_ids = [
      var.internal_https_traffic_security_group_id
    ]
    subnet_ids = [
      var.private_subnet_id
    ]
  } : {
    security_group_ids = []
    subnet_ids = []
  }
}
