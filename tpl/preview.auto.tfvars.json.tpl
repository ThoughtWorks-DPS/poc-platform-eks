{
    "aws_region": "us-west-2",
    "assume_role": "DPSTerraformRole",
    "account_id": "{{ vapoc/platform/svc/aws/aws-account-id }}",

    "cluster_name": "preview",
    "cluster_version": "1.17",
    "node_group_a_desired_capacity": "1",
    "node_group_a_max_capacity": "3",
    "node_group_a_min_capacity": "1",
    "node_group_a_disk_size": "80",
    "node_group_a_instance_type": "m5.xlarge"
  }
