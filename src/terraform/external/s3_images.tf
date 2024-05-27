# Created referring to:
# HashiCorp. 2023. 'Resource: aws_s3_bucket'.
# Retrieved from https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
#
# HashiCorp. 2023. 'Resource: aws_s3_bucket_policy'.
# Retrieved from https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy
#
# Amazon Web Services, Inc. 2023. 'Permissions for the Amazon S3 Bucket'.
# Retrieved from https://docs.aws.amazon.com/config/latest/developerguide/s3-bucket-policy.html
#
# Singh, N. 2017. 'Access to User level folders using Amazon S3 and Cognito'.
# Retrieved from https://medium.com/@inishant/access-to-user-level-folders-using-amazon-s3-and-cognito-469e80dce4c6
#
# HashiCorp. 2023. 'Resource: aws_s3_bucket_public_access_block'.
# Retrieved from https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block
#
# HashiCorp. 2023. 'Resource: aws_s3_bucket_cors_configuration'.
# Retrieved from https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_cors_configuration

# For authenticated access to this to make sense, we probably at least would need an identity pool, which it 
# seems has not yet been set up.
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_identity_pool

resource "aws_s3_bucket" "images_bucket" {
  bucket = "fit5225-group-44-images-bucket-${var.bucket_suffix}"
  force_destroy = true
}
