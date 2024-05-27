# Created referring to:
# HashiCorp. 2023. 'Resource: aws_dynamodb_table'.
# Retrieved from https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table

resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name = "photos"
  billing_mode = "PAY_PER_REQUEST"
  deletion_protection_enabled = var.table_deletion_protection
  hash_key = "url"
  range_key = "user_id"

  attribute {
    name = "url"
    type = "S"
  }

  attribute {
    name = "user_id"
    type = "S"
  }
}
