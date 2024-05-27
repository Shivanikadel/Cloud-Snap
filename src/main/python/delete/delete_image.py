# Created reffering to: 
# https://docs.aws.amazon.com/lambda/latest/dg/lambda-python.html
# https://docs.aws.amazon.com/lambda/latest/dg/python-handler.html
#
# Amazon Web Services, Inc. 2023. 'list_buckets'.
# Retrieved from https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/s3/client/list_buckets.html

# Image Deletion from DynamoDB and S3
# Context Path: /v1/api/data/

# Method: DELETE

# Headers:

# Content-Type: application/json
# Request body:

# {
#     "user_id": "123456789"
#     "url": "https://..."
# }


import boto3
import botocore
import json

def lambda_handler(event, context):
    try:
        # Retrieve user_id and url from the request body
        request_body = json.loads(event['body'])
        user_id = request_body.get('user_id')
        url = request_body.get('url')
        
        if not user_id or not url:
            return {
                'statusCode': 400,
                'body': json.dumps({'error': 'Invalid request body.'})
            }
        
        # Delete the image from DynamoDB
        dynamodb = boto3.resource('dynamodb')
        table = dynamodb.Table('photos')
        
        table.delete_item(Key={'user_id': user_id, 'url': url})
        
        # Delete the image from S3
        s3 = boto3.client('s3')
        
        response = s3.list_buckets()
        buckets = response['Buckets']
        
        bucket_name = None
        for bucket in buckets:
            if bucket['Name'].startswith("fit5225-group-44-images-bucket-"):
                bucket_name = bucket['Name']
                break
        
        if not bucket_name:
            return {
                'statusCode': 500,
                'body': json.dumps({'error': 'S3 bucket not found.'})
            }
        
        try:
            s3.delete_object(Bucket=bucket_name, Key=url.split('/')[-1])
        except botocore.exceptions.ClientError as e:
            if e.response['Error']['Code'] == "404":
                return {
                    'statusCode': 404,
                    'body': json.dumps({'error': 'Image URL not found in S3 bucket.'})
                }
            else:
                raise
        
        return {
            'statusCode': 200,
            'body': json.dumps({'message': 'Image deleted successfully.'})
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }
