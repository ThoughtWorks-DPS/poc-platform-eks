#!/usr/bin/env bash

export AWS_ACCOUNT_ID=$(secrethub read vapoc/platform/svc/aws/aws-account-id)

# write cluster kubeconfig
sed -n '/users/q;p' kubeconfig_${1} > kubeconfig_context.tpl
cat <<EOF > kubeconfig_token.tpl
users:
- name: eks_${1}
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: aws
      args:
        - "eks"
        - "get-token"
        - "--cluster-name"
        - "${1}"
        - "--role"
        - "arn:aws:iam::${AWS_ACCOUNT_ID}:role/DPSTerraformRole"

EOF
cat kubeconfig_context.tpl kubeconfig_token.tpl > kubeconfig
cat kubeconfig | secrethub write vapoc/platform/env/${1}/cluster/kubeconfig
curl -LOs https://raw.githubusercontent.com/ThoughtWorks-DPS/poc-resources/main/pipeline_helpers/assume_role.sh
source assume_role.sh "LHDITerraformRole" "poc-platform-eks-session"
cat kubeconfig | chamber write lhdi/platform/env/${1}/cluster kubeconfig -
