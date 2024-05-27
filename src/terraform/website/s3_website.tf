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
# HashiCorp. 2023. 'Resource: aws_s3_bucket_website_configuration'.
# Retrieved from https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration

resource "aws_s3_bucket" "website_bucket" {
  bucket = "s3-image-detection-${var.bucket_suffix}"
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "website_bucket_public_access" {
  bucket = aws_s3_bucket.website_bucket.id
  block_public_acls = true
  ignore_public_acls = true
  block_public_policy = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "s3_website_configuration" {
  bucket = aws_s3_bucket.website_bucket.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_policy" "allow_user_access_to_folders" {
  bucket = aws_s3_bucket.website_bucket.id
  policy = data.aws_iam_policy_document.website_bucket_policy_document.json

  depends_on = [ 
    aws_s3_bucket_public_access_block.website_bucket_public_access
  ]
}

data "aws_iam_policy_document" "website_bucket_policy_document" {
  statement {
    sid = "AllowGetObject"
    effect = "Allow"
    
    principals {
      type = "*"
      identifiers = [
        "*"
      ]
    }

    resources = [ 
      "${aws_s3_bucket.website_bucket.arn}/*"
    ]

    actions = [
      "s3:GetObject"
    ]
  }
}
