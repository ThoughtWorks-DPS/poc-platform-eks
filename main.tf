module "eks" {
  source       = "terraform-aws-modules/eks/aws"
  version      = "12.2.0"

  cluster_name = var.cluster_name
  cluster_version = var.cluster_version
  cluster_enabled_log_types = var.cluster_enabled_log_types
  cluster_encryption_config = [
    {
      provider_key_arn = aws_kms_key.cluster_encyption_key.arn
      resources        = ["secrets"]
    }
  ]
  
  enable_irsa  = true
  vpc_id       = data.aws_vpc.cluster_vpc.id
  subnets      = data.aws_subnet_ids.private.ids
  
  node_groups_defaults = {
    ami_type  = "AL2_x86_64"
    disk_size = 80
  }
  node_groups = {
    side_a = {
      desired_capacity = var.node_group_a_desired_capacity
      max_capacity     = var.node_group_a_max_capacity
      min_capacity     = var.node_group_a_min_capacity
      disk_size        = var.node_group_a_disk_size
      instance_type    = var.node_group_a_instance_type
      k8s_labels = {
        Environment = "${var.cluster_name}"
      }
      additional_tags = {
        "cluster" = "${var.cluster_name}"
        "pipeline" = "poc-platform-eks"
        "k8s.io/cluster-autoscaler/enabled" = "true"
        "k8s.io/cluster-autoscaler/${var.cluster_name}" = "true"
      }
    }
  }
  kubeconfig_aws_authenticator_command = "aws"
  wait_for_cluster_cmd = "until curl -k -s $ENDPOINT/healthz >/dev/null; do sleep 4; done"
}

resource "aws_kms_key" "cluster_encyption_key" {
  description = "Encryption key for kubernetes-secrets envelope encryption"
  enable_key_rotation = true
  deletion_window_in_days = 7
}
