# Created referring to:
# HashiCorp. 2023. 'Resource: aws_s3_bucket'.
# Retrieved from https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
#
# Amazon Web Services, Inc. 2023. 'Permissions for the Amazon S3 Bucket'.
# Retrieved from https://docs.aws.amazon.com/config/latest/developerguide/s3-bucket-policy.html

resource "aws_s3_bucket" "code_bucket" {
  bucket = "fit5225-group-44-code-bucket-${var.bucket_suffix}"
  force_destroy = true
}

# We do not provide an access policy for this particular bucket as 
# its contents are not to be shared. Instead, they provide source 
# code to AWS Lambda functions.
