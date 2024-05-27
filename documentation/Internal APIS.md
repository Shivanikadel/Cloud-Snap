# Internal APIs
Access authorised to AWS Lambda by IAM roles.

## Image Object Detection
Context Path:   /api/iod/

Method:         POST

Headers:
  - Content-Type: application/json

Request body:
```
{
    "image": "BASE64-encoded image here"
}
```

Response body:
```
{
    "tags": [
        {
            "tag": "SOME OBJECT",
            "count": 2
        },
        {
            "tag": "SOME OTHER OBJECT"
        }
    ]
}
```

## Image Insertion to DynamoDB and S3
Context Path:   /api/data/

Method:         POST

Headers:
  - Content-Type: application/json

Request body:
```
{
    "user_id": "123456789",
    "image": "BASE64-encoded image here",
    "tags": [
        {
            "tag": "SOME OBJECT",
            "count": 2
        },
        {
            "tag": "SOME OTHER OBJECT"
        }
    ]
}
```

Response body:
```
{
    "url": "https://..."
}
```

## Image Deletion from DynamoDB and S3
Context Path:   /api/data/

Method:         DELETE

Headers:
  - Content-Type: application/json

Request body:
```
{
    "user_id": "123456789",
    "url": "https://..."
}
```

## Image Update from DynamoDB
Context Path:   /api/data/

Method:         PUT

Headers:
  - Content-Type: application/json

Request body:
```
{
    "user_id": "123456789",
    "url": "https://...",
    "type": 1,
    "tags": [
        {
            "tag": "SOME OBJECT",
            "count": 2
        },
        {
            "tag": "SOME OTHER OBJECT"
        }
    ]
}
```

Response body:
```
{
    "url": "https://...",
    "tags": [
        {
            "tag": "SOME OBJECT",
            "count": 2
        },
        {
            "tag": "SOME OTHER OBJECT"
        }
    ]
}
```

Comments: We can customise the expected request body for this endpoint as it is internal (if a different scheme is more suitable)

## Image Search by tags from DynamoDB
Context Path:   /api/data/

Method:         GET

Headers:
  - Content-Type: application/json

Request body:
```
{
    "user_id": "123456789",
    "tags": [
        {
            "tag": "SOME OBJECT",
            "count": 2
        },
        {
            "tag": "SOME OTHER OBJECT"
        }
    ]
}
```

Response body:
```
{
    "links": [
        "https://...",
        "https://..."
    ]
}
```
