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
---
apiVersion: v1
kind: Namespace
metadata:
  name: api-2-dev
  labels:
    name: api-2-dev
    istio-injection: enabled
---
apiVersion: v1
kind: Namespace
metadata:
  name: api-2-staging
  labels:
    name: api-2-staging
    istio-injection: enabled
EOF

kubectl apply -f namespace_environments.yaml
