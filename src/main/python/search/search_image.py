# Created reffering to: 
# https://docs.aws.amazon.com/lambda/latest/dg/lambda-python.html
# https://docs.aws.amazon.com/lambda/latest/dg/python-handler.html
#
# Amazon Web Services, Inc. 2023. 'list_buckets'.
# Retrieved from https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/s3/client/list_buckets.html

# Image Search by tags from DynamoDB
# Context Path: /v1/api/data/

# Method: GET

# Headers:

# Content-Type: application/json
# Request body:

# {
#     "tags": [
#         {
#             "user_id": "123456789"
#             "tag": "SOME OBJECT",
#             "count": 2
#         },
#         {
#             "tag": "SOME OTHER OBJECT"
#         }
#     ]
# }
# Response body:

# {
#     "links": [
#         "https://...",
#         "https://..."
#     ]
# }

import json
import boto3

def lambda_handler(event, context):
    try:
        # Parse the request body from the event
        request_body = json.loads(event["body"])
        
        # Get the user ID and tags from the request body
        user_id = request_body["user_id"]
        tags = request_body["tags"]

        # Build the DynamoDB filter expression based on the provided tags and user ID
        filter_expression = "user_id = :user_id"
        expression_attribute_values = {":user_id": user_id}
        expression_attribute_names = {}

        for index, tag in enumerate(tags):
            tag_name = tag.get("tag")
            tag_count = tag.get("count")

            expression_attribute_names[f"#tag{index}"] = tag_name

            if tag_count:
                expression = f"attribute_exists(#tag{index}) AND #tag{index} >= :count_{index}"
                expression_attribute_values[f":count_{index}"] = tag_count
            else:
                expression = f"attribute_exists(#tag{index})"

            filter_expression += f" AND ({expression})"

        # Generate the S3 URLs for the image filenames
        dynamodb = boto3.resource('dynamodb')
        table_name = "photos"  # Replace with your DynamoDB table name
        table = dynamodb.Table(table_name)

        # Perform the DynamoDB query
        response = table.scan(
            FilterExpression=filter_expression,
            ExpressionAttributeNames=expression_attribute_names,
            ExpressionAttributeValues=expression_attribute_values
        )
        
        # Get the items directly from the DynamoDB response
        items = response.get("Items", [])

        # Generate the S3 URLs for the image filenames
        image_urls = [item["url"] for item in items]

        # Prepare the response body
        if image_urls:
            response_body = {"links": image_urls}
            status_code = 200
        else:
            response_body = {"message": ("Images not found, error if you are put ' ' instead of '_'") }
            status_code = 404

        return {
            "statusCode": status_code,
            "body": json.dumps(response_body)
        }

    except Exception as e:
        response = {
            "statusCode": 500,
            "body": json.dumps({
                "message": "Error searching images",
                "error": str(e)
            })
        }

        return response

