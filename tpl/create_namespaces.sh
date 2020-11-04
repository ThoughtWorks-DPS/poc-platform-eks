#!/usr/bin/env bash

cat << EOF > namespace_environments.yaml
---
apiVersion: v1
kind: Namespace
metadata:
  name: di-dev
  labels:
    name: di-dev
    istio-injection: enabled
---
apiVersion: v1
kind: Namespace
metadata:
  name: di-staging
  labels:
    name: di-staging
    istio-injection: enabled
EOF

kubectl apply -f namespace_environments.yaml
