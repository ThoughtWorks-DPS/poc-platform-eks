#!/usr/bin/env bash

cat << EOF > kube-secrets.yaml
---
apiVersion: v1
kind: Secret
metadata:
 name: github-packages-secret
data:
 .dockerconfigjson: eyJhdXRocyI6eyJodHRwczovL2RvY2tlci5wa2cuZ2l0aHViLmNvbSI6eyJ1c2VybmFtZSI6InR3ZHBzLmlvIiwicGFzc3dvcmQiOiJkYjg1ZjY0YjcyZGIxZWUxZTk4YjRkNmUwNTA4NjNkYWVmMTc2ZGUzIiwiYXV0aCI6ImRIZGtjSE11YVc4NlpHSTROV1kyTkdJM01tUmlNV1ZsTVdVNU9HSTBaRFpsTURVd09EWXpaR0ZsWmpFM05tUmxNdz09In19fQ==
type: kubernetes.io/dockerconfigjson
EOF

kubectl apply -f kube-secrets.yaml -n di-dev
kubectl apply -f kube-secrets.yaml -n di-staging
