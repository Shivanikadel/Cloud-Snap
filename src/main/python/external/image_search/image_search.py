# Created referring to:
# Amazon Web Services, Inc. 2023. 'Set up Lambda proxy integrations in API Gateway - Input format of a Lambda function for proxy integration'.
# Retrieved from https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-lambda-proxy-integrations.html#api-gateway-simple-proxy-for-lambda-input-format
#
# Amazon Web Services, Inc. 2023. 'Enabling CORS for a REST API resource'.
# Retrieved from https://docs.aws.amazon.com/apigateway/latest/developerguide/how-to-cors.html
#    Note: The following link is also helpful: https://fetch.spec.whatwg.org/#http-cors-protocol
#
# Amazon Web Services, Inc. 2023. 'get_rest_apis'.
# Retrieved from https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/apigateway/client/get_rest_apis.html

from sys import path
path.append('dependencies')

from typing import Dict, Any
import json
import requests
import boto3

STATUS_CODE: str = "statusCode"
HEADERS: str = "headers"
BODY: str = "body"

def get_response(code: int, body: Dict) -> Dict:
  return {
        STATUS_CODE: code,
        HEADERS: {
          "Content-Type": "application/json",
          "Access-Control-Allow-Headers": "Content-Type",
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Allow-Methods": "OPTIONS,POST,DELETE"
        },
        BODY: json.dumps(body)
      }

def handler(event: Dict, context: Any):
  try:
    request_body: Dict = json.loads(event["body"])
    user_id: str = event["requestContext"]["authorizer"]["claims"]["sub"]
    
    client = boto3.client('apigateway')
    
    internal_api = list(map(lambda item: item["id"],
      filter(lambda item: item["name"] == "cloud-snap-internal-api", 
      client.get_rest_apis(limit=2)["items"])))[0]
    
    tags = []
    if "image" in request_body:
      image: str = request_body["image"]
      if "tags" in request_body:
        raise ValueError("Invalid arguments")
      # Submit image for object detections
      tags = requests.post(f"https://{internal_api}.execute-api.us-east-1.amazonaws.com/cloud-snap/api/iod", 
                         data = json.dumps({
                           "image": image
                         }), headers = {
                           "Content-Type": "application/json"
                         }).json()["tags"]
    elif "tags" in request_body:
      tags = request_body["tags"]

    image_search_request = {
      "user_id": user_id,
      "tags": tags
    }

    response = requests.get(f"https://{internal_api}.execute-api.us-east-1.amazonaws.com/cloud-snap/api/data/", 
                             data = json.dumps(image_search_request), 
                             headers = {
                              "Content-Type": "application/json"
                             })
    response.raise_for_status()

    return get_response(200, response.json())
  except:
    return get_response(400, {
      "Message": "Bad Request"
    })
