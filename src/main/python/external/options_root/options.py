# Created referring to:
# Amazon Web Services, Inc. 2023. 'Enabling CORS for a REST API resource'.
# Retrieved from https://docs.aws.amazon.com/apigateway/latest/developerguide/how-to-cors.html
#    Note: The following link is also helpful: https://fetch.spec.whatwg.org/#http-cors-protocol

from typing import Dict, Any
import json

STATUS_CODE: str = "statusCode"
HEADERS: str = "headers"
BODY: str = "body"

def get_response(code: int, body: Dict) -> Dict:
  return {
        STATUS_CODE: code,
        HEADERS: {
          "Content-Type": "application/json",
          "Access-Control-Allow-Headers": "Content-Type,Authorization",
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Allow-Methods": "OPTIONS"
        },
        BODY: json.dumps(body)
      }

def handler(event: Dict, context: Any):
  return get_response(200, {})
