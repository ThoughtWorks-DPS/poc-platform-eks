#!/usr/bin/env bash

export GITHUB_USER=$(secrethub read vapoc/platform/svc/github/username)
export GITHUB_TOKEN=$(secrethub read vapoc/platform/svc/github/access-token)

export username=$(echo $GITHUB_USER | base64)
export password=$(echo $GITHUB_TOKEN | base64)

cat << EOF > kube-secrets.yaml
---
apiVersion: v1
kind: Secret
metadata:
  name: github-packages-secret
data:
  username: ${username}
  password: ${password}
EOF

kubectl apply -f kube-secrets.yaml -n di-dev
kubectl apply -f kube-secrets.yaml -n di-staging
