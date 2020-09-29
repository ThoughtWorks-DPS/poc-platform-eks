#!/usr/bin/env bash

export AWS_ACCOUNT_ID=$(secrethub read vapoc/platform/svc/aws/aws-account-id)
export AWS_DEFAULT_REGION=${2}

# write cluster-autoscaler-chart-values.yaml
cat <<EOF > container-insights/cloudwatch/cloudwatch-serviceaccount.yaml
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: cloudwatch-agent
  namespace: amazon-cloudwatch
  annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::${AWS_ACCOUNT_ID}:role/${1}-cloud-watch

EOF

# create configmap for cwagent config
cat  <<EOF > container-insights/cloudwatch/cloudwatch-agent-configmap.yaml
apiVersion: v1
data:
  cwagentconfig.json: |
    {
      "logs": {
        "metrics_collected": {
          "kubernetes": {
            "cluster_name": "${1}",
            "metrics_collection_interval": 20
          }
        },
        "force_flush_interval": 5
      },
      "metrics": {
          "metrics_collected": {
              "statsd": {
                  "service_address": ":8125"
              }
          }
      }
    }
kind: ConfigMap
metadata:
  name: cwagentconfig
  namespace: amazon-cloudwatch
EOF

cat  <<EOF > container-insights/fluentd/fluentd-configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: cluster-info
  namespace: amazon-cloudwatch
data:
  cluster.name: ${1}
  logs.region: ${2}
EOF

kubectl apply -f container-insights/cloudwatch-namespace.yaml
kubectl apply -f container-insights/cloudwatch/ --recursive
kubectl apply -f container-insights/fluentd/ --recursive

# fluentd takes a few seconds to get to a ready state
sleep 15
