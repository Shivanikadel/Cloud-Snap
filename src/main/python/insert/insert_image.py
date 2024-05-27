# Created referring to:
# Amazon Web Services, Inc. 2023. 'Lambda function handler in Python'.
# Retrieved from https://docs.aws.amazon.com/lambda/latest/dg/python-handler.html

# Image Insertion to DynamoDB and S3
# Context Path: /v1/api/data/

# Method: POST
# Headers:

# Content-Type: application/json
# Request body:

# {
#     "user_id": "123456789"   
#     "image": "BASE64-encoded image here",
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
#     "url": "https://..."
# }


import boto3
import json
import base64
from datetime import datetime
import uuid

s3_client = boto3.client('s3')
dynamodb = boto3.resource('dynamodb')

def lambda_handler(event, context):
    try:
        # Get the user ID, image data, and tags from the request body
        request_body = json.loads(event["body"])
        user_id = request_body["user_id"]
        image_data = request_body["image"]
        tags = request_body["tags"]

        # Decode the Base64 image data
        image_bytes = base64.b64decode(image_data)

        # Generate a unique filename for the image
        timestamp = datetime.now().strftime("%Y%m%d%H%M%S")
        unique_id = str(uuid.uuid4())
        image_filename = f"image_{timestamp}_{unique_id}.jpg"

        # Save the image to the S3 bucket
        bucket_name = list(filter(lambda name: name.startswith("fit5225-group-44-images-bucket"), map(lambda bucket: bucket["Name"], s3_client.list_buckets()["Buckets"])))[0]
        s3_client.put_object(
            Body=image_bytes,
            Bucket=bucket_name,
            Key=image_filename
        )
        
        # Save the image details and tags to DynamoDB
        table_name = "photos"  # Replace with your DynamoDB table resource name
        table = dynamodb.Table(table_name)

        # Modify the item dictionary to include tags as attributes
        item = {
            "user_id": user_id,
            "url": f"https://{bucket_name}.s3.amazonaws.com/{image_filename}",
        }
        for tag in tags:
            tag_name = tag.get("tag")
            tag_count = tag.get("count")
            if "_" in tag_name:
                raise ValueError("Invalid tag name. Underscores are not allowed.")
            if tag_name:
                item[tag_name] = tag_count if tag_count else 1

        table.put_item(Item=item)

        
        response = {
            "url": f"https://{bucket_name}.s3.amazonaws.com/{image_filename}"
        }

        return {
            "statusCode": 200,
            "body": json.dumps(response)
        }

    except Exception as e:
        response = {
            "statusCode": 500,
            "body": json.dumps({
                "message": "Error inserting image",
                "error": str(e)
            })
        }

        return response
