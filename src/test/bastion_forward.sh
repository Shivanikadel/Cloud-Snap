#!/bin/bash
# Created referring to:
# Amazon Web Services, Inc. 2023. 'Filtering AWS CLI output'.
# Retrieved from https://docs.aws.amazon.com/cli/latest/userguide/cli-usage-filter.html
#
# Linuxize. 2020. 'How to Set up SSH Tunneling (Port Forwarding)'.
# Retrieved from https://linuxize.com/post/how-to-setup-ssh-tunneling/

IDENTITY=$1
BASTION_IP_ADDRESS=$2
if [[ -z ${IDENTITY} ]]; then
  echo "Must specify identity file"
  exit 1
fi
if [[ -z ${BASTION_IP_ADDRESS} ]]; then
  echo "Must specify bastion host IP address"
  exit 1
fi

API_GATEWAY_ID="$(aws apigateway get-rest-apis --query "items[?name=='cloud-snap-internal-api'].id" --output=text)"
API_GATEWAY_ENDPOINT="${API_GATEWAY_ID}.execute-api.us-east-1.amazonaws.com"

ssh -4 -i ${IDENTITY} -L "8080:${API_GATEWAY_ENDPOINT}:443" ubuntu@${BASTION_IP_ADDRESS}
