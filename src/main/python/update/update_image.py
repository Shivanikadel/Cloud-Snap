# Created reffering to: 
# https://docs.aws.amazon.com/lambda/latest/dg/lambda-python.html
# https://docs.aws.amazon.com/lambda/latest/dg/python-handler.html
# Image Update from DynamoDB
# Context Path: /v1/api/data/

# Method: PUT

# Headers:

# Content-Type: application/json
# Request body:

# {
#     "user_id": "123456789",
#     "url": "https://...",
#     "type": 1,
#     "tags": [
#         {
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
#     "url": "https://...",
#     "tags": [
#         {
#             "tag": "SOME OBJECT",
#             "count": 2
#         },
#         {
#             "tag": "SOME OTHER OBJECT"
#         }
#     ]
# }
#tags unerscore not fixed, can be ignored

import boto3
import json

dynamodb = boto3.resource('dynamodb')

def lambda_handler(event, context):
    try:
        # Get the request body parameters
        request_body = json.loads(event["body"])
        user_id = request_body["user_id"]
        url = request_body["url"]
        image_type = request_body["type"]
        tags = request_body["tags"]

        # Update the image in DynamoDB
        table_name = "photos"  # Replace with your DynamoDB table resource name
        table = dynamodb.Table(table_name)

        
        if image_type == 1:
            # Adding tags
            for tag in tags:
                tag_name = tag["tag"]
                tag_count = tag.get("count", 1)
                response = table.update_item(
                    Key={"user_id": user_id, "url": url},
                    UpdateExpression=f"SET #{tag_name.replace(' ', '_')} = :count",
                    ExpressionAttributeNames={f"#{tag_name.replace(' ', '_')}": tag_name},
                    ExpressionAttributeValues={":count": tag_count},
                    ReturnValues="UPDATED_NEW"
                )
        elif image_type == 0:
            # Removing tags
            remove_tags = [tag["tag"] for tag in tags]
            expression_attribute_names = {}
            update_expression = "REMOVE "
            for i, tag_name in enumerate(remove_tags):
                attribute_name = f"#tag{i}"
                expression_attribute_names[attribute_name] = tag_name
                update_expression += f"{attribute_name}, "
            update_expression = update_expression.rstrip(", ")

            response = table.update_item(
                Key={"user_id": user_id, "url": url},
                UpdateExpression=update_expression,
                ExpressionAttributeNames=expression_attribute_names,
                ReturnValues="UPDATED_NEW"
            )
        else:
            # Invalid image_type value
            response = {
                "statusCode": 400,
                "body": json.dumps({"message": "Invalid image_type value"})
            }
            return response

        return {"statusCode": 200, "body": json.dumps({})}

    except Exception as e:
        response = {
            "statusCode": 500,
            "body": json.dumps({"message": "Error updating image", "error": str(e)})
        }

        return response

