# poc-platform-eks

## current configuration

- Uses EKS latest k8s version (1.17)
- Control plane logging default = "api", "audit", "authenticator"
- Control plan internals (data, secrets, etc) encrypted using generated kms key
- Uses managed node_groups for worker pools
- baseline config includes cluster-autoscaler, metrics-server, kube-state-metrics, and AWS container-insights (aggregation)
- OIDC for service accounts (irsa) is configured and used for cluster-autoscaler, cloud-watch
- Not configured to support "stateful" applications backed by EBS volumes


# NEED TODO

- deploy [External-DNS](https://github.com/kubernetes-sigs/external-dns/blob/master/docs/tutorials/aws.md)


# Probably don't need to do for poc

- not forwarding kube-state-metrics to container-insights, probably not necessary for poc

Given poc, limited configuration testing to the basics. operational deployment would require:

- test metrics-server and kube-state-metrics for actual outputs and test aggregation for presence of the metrics
- test aws container-insight aggregation for results
- test cluster-autoscaler response to load
