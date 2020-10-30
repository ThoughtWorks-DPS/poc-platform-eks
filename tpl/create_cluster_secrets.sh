#!/usr/bin/env bash

export GITHUB_USER=$(secrethub read vapoc/platform/svc/github/username)
export GITHUB_TOKEN=$(secrethub read vapoc/platform/svc/github/access-token)

kubectl create secret docker-registry github-package-cred \
  --docker-server=https://docker.pkg.github.com \
  --docker-username=$GITHUB_USER \
  --docker-password=$GITHUB_TOKEN
