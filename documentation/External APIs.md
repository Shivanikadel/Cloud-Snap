# External APIs for Managing Images
Users need to authenticate with Amazon Cognito, and likely obtain some short-lived credential/token which will allow them access to a variety of REST APIs. Perhaps we want the APIs to be invoked by the client JavaScript in web pages they access (e.g. perhaps users visit a page, interact with buttons/forms on it, and those forms then result in requests being sent to the API Gateway)?

Additionally, users should only be able to retrieve and alter images which they have uploaded and are hence authorised to view.

## Image Upload
Context Path:   /api/image/

Method:         POST

Headers:
  - Content-Type: application/json
  - (authorisation from Amazon Cognito)

Request body:
```
{
    "image": "BASE64-encoded image here"
}
```

# FIXME: Not deleting from S3
## Image Deletion
Context Path:   /api/image/

Method:         DELETE

Headers:
  - Content-Type: application/json
  - (authorisation from Amazon Cognito)

Request body:
```
{
    "url": "https://..."
}
```

Comments: The URL of the image to be deleted.

# FIXME: Not working
## Image Tag Update (Addition and Removal)
Context Path:   /api/tags/

Method:         POST

Headers:
  - Content-Type: application/json
  - (authorisation from Amazon Cognito)

Request body:
```
{
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


## Image Search by Tags and Counts
Context Path:   /api/images/

Method:         POST

Headers:
  - Content-Type: application/json
  - (authorisation from Amazon Cognito)

Request body:
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

Response body:
```
{
    "links": [
        "https://...",
        "https://..."
    ]
}
```

Comments: URLs returned should be embedded in the web page so that the matched images are displayed to the user. Tags in the request body form a logical conjunctive query, and when count is omitted, it is assumed to be 1.

## Image Search by Image
Context Path:   /api/images/

Method:         POST

Headers:
  - Content-Type: application/json
  - (authorisation from Amazon Cognito)

Request body:
```
{
    "image": "BASE64-encoded image here"
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

Comments: The uploaded image for this purpose must *not* be retained; they do need to be able to invoke the Yolo (likely internal) API, however, so this should ideally be decoupled from the S3 and database storage components.
