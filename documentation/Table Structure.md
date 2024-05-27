# DynamoDB Table Structure

Tags on images need to be stored as separate attributes in DynamoDB; for example, consider the following data:

```
{
  "url": "https://...",
  "tags": [
      {
          "tag": "some_object",
          "count": 2
      },
      {
          "tag": "some_other_object"
          "count": 1
      }
  ]
}
```


In DynamoDB, we insert the URL for the url attribute, and then a sequence of attributes of the form some_object=2 and some_other_object=1. We probably want to be case-insensitive when considering tags input to the search API. Then the table could look like

|     url       |   user_id   | some_object | some_other_object | another_object |
|---------------|-------------|-------------|-------------------|----------------|
| "https://..." |     xyz     |             |         1         |       6        |
| "https://..." |     abc     |      2      |         1         |                |

assuming a pre-existing image which features another_object, but does not feature some_object.
