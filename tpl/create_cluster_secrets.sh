#!/usr/bin/env bash

GITHUB_USERNAME=$(secrethub read vapoc/platform/svc/github/username)
GITHUB_TOKEN=$(secrethub read vapoc/platform/svc/github/access-token)
EMAIL=$(secrethub read vapoc/platform/svc/gmail/username)

kubectl create secret docker-registry github-packages-secret --docker-username=$GITHUB_USERNAME --docker-password=$GITHUB_TOKEN --docker-email=$EMAIL --docker-server=docker.pkg.github.com -n di-dev --dry-run=client -o yaml > dev-secret.yaml
kubectl apply -f dev-secret.yaml

kubectl create secret docker-registry github-packages-secret --docker-username=$GITHUB_USERNAME --docker-password=$GITHUB_TOKEN --docker-email=$EMAIL --docker-server=docker.pkg.github.com -n di-staging --dry-run=client -o yaml > staging-secret.yaml
kubectl apply -f staging-secret.yaml
