#!/usr/bin/env bats
@test "evaluate cluster-autoscaler status" {
  run bash -c "kubectl get po -n kube-system -o wide | grep 'cluster-autoscaler'"
  [[ "${output}" =~ "Running" ]]
}

@test "evaluate metrics-server status" {
  run bash -c "kubectl get po -n kube-system -o wide | grep 'metrics-server'"
  [[ "${output}" =~ "Running" ]]
}

@test "evaluate kube-state-metrics status" {
  run bash -c "kubectl get po -n kube-system -o wide | grep 'kube-state-metrics'"
  [[ "${output}" =~ "Running" ]]
}

@test "evaluate cloudwatch-agent status" {
  run bash -c "kubectl get po -n amazon-cloudwatch -o wide | grep 'cloudwatch-agent'"
  [[ "${output}" =~ "Running" ]]
}

@test "evaluate fluentd status" {
  run bash -c "kubectl get po -n amazon-cloudwatch -o wide | grep 'fluentd'"
  [[ "${output}" =~ "Running" ]]
}

@test "evaluate di-dev namespace status" {
  run bash -c "kubectl get namespace | grep 'di-dev'"
  [[ "${output}" =~ "Active" ]]
}

@test "evaluate di-dev namespace status" {
  run bash -c "kubectl get namespace | grep 'di-staging'"
  [[ "${output}" =~ "Active" ]]
}

@test "evaluate di-dev namespace istio-injection" {
    run bash -c "kubectl get namespaces --show-labels | grep 'di-dev'"
    [[ "${output}" =~ "istio-injection=enabled" ]]
}

@test "evaluate di-staging namespace istio-injection" {
    run bash -c "kubectl get namespaces --show-labels | grep 'di-staging'"
    [[ "${output}" =~ "istio-injection=enabled" ]]
}

@test "evaluate cluster secrets in di-dev" {
  run bash -c "kubectl get secrets -n di-dev | grep 'github-packages-secret'"
  [[ "${output}" =~ "kubernetes.io/dockerconfigjson" ]]
}

@test "evaluate cluster secrets in di-staging" {
  run bash -c "kubectl get secrets -n di-staging | grep 'github-packages-secret'"
  [[ "${output}" =~ "kubernetes.io/dockerconfigjson" ]]
}
