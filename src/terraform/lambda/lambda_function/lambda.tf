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
# Moein. 2018. 'Answer to: terraform does not detect changes to lambda source files'.
# Retrieved from https://stackoverflow.com/a/53532857
#
# HashiCorp. 2023. 'Resource: aws_s3_object'.
# Retrieved from https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object
#
# Baker, J. 2023. 'Optionally replace Lambda function ENI security groups on destroy'.
# Retrieved from https://github.com/hashicorp/terraform-provider-aws/pull/29289
#
# ascopes. 2023. '[Bug] aws_lambda_function.replace_security_groups_on_destroy behaviour is no longer supported'.
# Retrieved from https://github.com/hashicorp/terraform-provider-aws/issues/31520
#
# Halfpenny, P. 2023. 'Comment on: [Bug] aws_lambda_function.replace_security_groups_on_destroy behaviour is no longer supported'.
# Retrieved from https://github.com/hashicorp/terraform-provider-aws/issues/31520#issuecomment-1564294438
#
# Amazon Web Services, Inc. 2023. 'describe-security-groups'.
# Retrieved from https://docs.aws.amazon.com/cli/latest/reference/ec2/describe-security-groups.html

data "archive_file" "function" {
  type = "zip"
  excludes = [ "requirements.txt" ]
  source_dir = "${path.module}/../../../${var.source_dir}"
  output_file_mode = "0666"
  output_path = "${path.module}/../../../build/${var.source_dir}.zip"
}

resource "aws_s3_object" "source_code" {
  bucket = var.s3_bucket
  key = "${var.name}-source-code.zip"
  source = data.archive_file.function.output_path
  source_hash = data.archive_file.function.output_base64sha256
}

resource "aws_lambda_function" "lambda_function" {
  s3_bucket = aws_s3_object.source_code.bucket
  s3_key = aws_s3_object.source_code.key
  function_name = var.name
  runtime = var.runtime
  handler = var.handler
  memory_size = var.memory_allocation
  timeout = var.timeout
  role = var.lab_role_arn
  source_code_hash = data.archive_file.function.output_base64sha256

  vpc_config {
    security_group_ids = var.vpc_config.security_group_ids
    subnet_ids = var.vpc_config.subnet_ids
  }

  # This was intended as a work-around to assign the AWS Lambda functions the default security group prior to their deletion,
  # in the hopes of speeding up the deletion times. Changing the security group on an ENI associated with a Lambda appears to 
  # now be disallowed by AWS, which was the original workaround for the slow deletion times.
  #
  # provisioner "local-exec" {
  #   when = destroy
  #   command = "aws lambda update-function-configuration --function-name ${self.function_name} --vpc-config SecurityGroupIds=$(aws ec2 describe-security-groups --group-names default --query SecurityGroups[0].GroupId --filters Name=tag:project,Values='cloud-snap')"
  # }
}
  