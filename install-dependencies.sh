#!/bin/bash

# Install dependencies into a "dependencies" directory alongside AWS Lambda code. See
# Amazon Web Services, Inc. 2023. 'Deploy Python Lambda functions with .zip file archives'.
# Retrieved from https://docs.aws.amazon.com/lambda/latest/dg/python-package.html
#
# Machado, D. 2022. 'Handling AWS Lambda Python Dependencies'.
# Retrieved from https://www.serverless.com/blog/handling-aws-lambda-python-dependencies

echo "Detection..."
(cd src/main/python/detection && pip install --no-cache-dir --target ./dependencies -r requirements.txt)
echo "Upload..."
(cd src/main/python/external/image_upload && pip install --no-cache-dir --target ./dependencies requests=='2.31.0')
echo "Update..."
cp -r src/main/python/external/image_upload/dependencies src/main/python/external/image_tag_update/dependencies
echo "Delete..."
cp -r src/main/python/external/image_upload/dependencies src/main/python/external/image_delete/dependencies
echo "Search..."
cp -r src/main/python/external/image_upload/dependencies src/main/python/external/image_search/dependencies
echo "Done!"
