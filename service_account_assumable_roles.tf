locals {
  k8s_cluster_autoscaler_namespace             = "kube-system"
  k8s_cluster_autoscaler_service_account_name  = "${var.cluster_name}-aws-cluster-autoscaler"

  k8s_cloud_watch_agents_account_namespace     = "amazon-cloudwatch"
  k8s_cloud_watch_agents_service_account_name  = "${var.cluster_name}-cloudwatch-agent"
}

# cluster-autoscaler
module "iam_assumable_role_admin" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = ">= v3.3.0"

  create_role                   = true
  role_name                     = "${var.cluster_name}-cluster-autoscaler"
  provider_url                  = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              = [aws_iam_policy.cluster_autoscaler.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:${local.k8s_cluster_autoscaler_namespace}:${local.k8s_cluster_autoscaler_service_account_name}"]
  number_of_role_policy_arns    = 1
}

resource "aws_iam_policy" "cluster_autoscaler" {
  name_prefix = "${var.cluster_name}-cluster-autoscaler"
  description = "EKS cluster-autoscaler policy for the ${var.cluster_name} cluster"
  policy      = data.aws_iam_policy_document.cluster_autoscaler.json
}

data "aws_iam_policy_document" "cluster_autoscaler" {
  statement {
    sid    = "${var.cluster_name}ClusterAutoscalerAll"
    effect = "Allow"

    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeTags",
      "ec2:DescribeLaunchTemplateVersions",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "${var.cluster_name}ClusterAutoscalerOwn"
    effect = "Allow"

    actions = [
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
      "autoscaling:UpdateAutoScalingGroup",
    ]

    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "autoscaling:ResourceTag/kubernetes.io/cluster/${module.eks.cluster_id}"
      values   = ["owned"]
    }

    condition {
      test     = "StringEquals"
      variable = "autoscaling:ResourceTag/k8s.io/cluster-autoscaler/enabled"
      values   = ["true"]
    }
  }
}

#cloudwatch-agents
module "iam_assumable_role_cloudwatch" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = ">= v3.3.0"

  create_role                   = true
  role_name                     = "${var.cluster_name}-cloudwatch-agent"
  provider_url                  = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              = [aws_iam_policy.cloud_watch.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:${local.k8s_cloud_watch_agents_account_namespace}:${local.k8s_cloud_watch_agents_service_account_name}"]
  number_of_role_policy_arns    = 1
}

resource "aws_iam_policy" "cloud_watch" {
  name_prefix = "${var.cluster_name}-cloud-watch"
  description = "EKS cloud_watch policy for the ${var.cluster_name} cluster"
  policy      = data.aws_iam_policy_document.cloud_watch.json
}

data "aws_iam_policy_document" "cloud_watch" {
  statement {
    sid    = "${var.cluster_name}CloudWatchSources"
    effect = "Allow"

    actions = [
      "cloudwatch:PutMetricData",
      "ec2:DescribeVolumes",
      "ec2:DescribeTags",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams",
      "logs:DescribeLogGroups",
      "logs:CreateLogStream",
      "logs:CreateLogGroup"
    ]

    resources = ["*"]
  }

  statement {
    sid    = "${var.cluster_name}CloudWatchSSM"
    effect = "Allow"

    actions = [
      "ssm:GetParameter"
    ]

    resources = ["arn:aws:ssm:*:*:parameter/AmazonCloudWatch-*"]
  }
}