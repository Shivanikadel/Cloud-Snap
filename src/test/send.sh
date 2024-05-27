#!/bin/bash
# Created referring to:
# Amazon Web Services, Inc. 2023. 'Filtering AWS CLI output'.
# Retrieved from https://docs.aws.amazon.com/cli/latest/userguide/cli-usage-filter.html
#
# Linuxize. 2020. 'How to Set up SSH Tunneling (Port Forwarding)'.
# Retrieved from https://linuxize.com/post/how-to-setup-ssh-tunneling/
#
# Josephus. 2021. 'Answer to: Failing to set up SSH tunnel to private AWS API gateway API'.
# Retrieved from https://stackoverflow.com/a/69802841

# Argument 1: method (e.g. GET, POST, PUT, DELETE)
# Argument 2: context path suffix (e.g. iod, data)
# Argument 3: file (e.g. test-case.json)

if [[ -z $1 ]]; then
  echo "Must specify method \\(e.g. GET, POST, PUT, DELETE\\)"
  exit 1
fi
if [[ -z $2 ]]; then
  echo "Must specify context path suffix \\(e.g. iod, data\\)"
  exit 1
fi
if [[ -z $3 ]]; then
  echo "Must specify data file"
  exit 1
fi

API_GATEWAY_ID="$(aws apigateway get-rest-apis --query "items[?name=='cloud-snap-internal-api'].id" --output=text)"
API_GATEWAY_ENDPOINT="${API_GATEWAY_ID}.execute-api.us-east-1.amazonaws.com"

curl -k -H "Host: ${API_GATEWAY_ENDPOINT}" -H "Content-Type: application/json" -X $1 https://localhost:8080/cloud-snap/api/$2 -d @$3
echo ""
