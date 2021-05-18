<div align="center">
	<p>
		<img alt="CircleCI Logo" src="https://github.com/ThoughtWorks-DPS/lab-documentation/blob/master/doc/img/dps.png?sanitize=true" width="75" />
	</p>
  <h5>archived</h5>
</div>
<br />

# poc-platform-eks

## current configuration
- Uses EKS latest k8s version (1.17)
- Control plane logging default = "api", "audit", "authenticator"
- Control plan internals (data, secrets, etc) encrypted using generated kms key
- Uses managed node_groups for worker pools
- baseline config includes cluster-autoscaler, metrics-server, kube-state-metrics, and AWS container-insights (aggregation)
- OIDC for service accounts (irsa) is configured and used for cluster-autoscaler, cloud-watch
- Not configured to support "stateful" applications backed by EBS volumes


## Run bats test
```sh
brew install bats
aws-vault exec vapoc.admin bats test
```

# Probably don't need to do for poc

- not forwarding kube-state-metrics to container-insights, probably not necessary for poc

Given poc, limited configuration testing to the basics. operational deployment would require:

- test metrics-server and kube-state-metrics for actual outputs and test aggregation for presence of the metrics
- test aws container-insight aggregation for results
- test cluster-autoscaler response to load
