#!/usr/bin/env bash
aws sts assume-role --output json --role-arn arn:aws:iam::{{ vapoc/platform/svc/aws/aws-account-id }}:role/DPSTerraformRole --role-session-name awspec-test > credentials

export AWS_ACCESS_KEY_ID=$(cat credentials | jq -r ".Credentials.AccessKeyId")
export AWS_SECRET_ACCESS_KEY=$(cat credentials | jq -r ".Credentials.SecretAccessKey")
export AWS_SESSION_TOKEN=$(cat credentials | jq -r ".Credentials.SessionToken")
export AWS_DEFAULT_REGION=$(cat $1.auto.tfvars.json | jq -r .aws_region)

bats test
