#!/usr/bin/env bash
aws sts assume-role --output json --role-arn arn:aws:iam::{{ vapoc/platform/svc/aws/aws-account-id }}:role/DPSTerraformRole --role-session-name awspec-test > credentials

export AWS_ACCESS_KEY_ID=$(cat credentials | jq -r ".Credentials.AccessKeyId")
export AWS_SECRET_ACCESS_KEY=$(cat credentials | jq -r ".Credentials.SecretAccessKey")
export AWS_SESSION_TOKEN=$(cat credentials | jq -r ".Credentials.SessionToken")
export AWS_DEFAULT_REGION=$(cat $1.auto.tfvars.json | jq -r .aws_region)

rspec

cat << EOF > kube-bench.yaml
---
apiVersion: batch/v1
kind: Job
metadata:
  name: kube-bench
spec:
  template:
    spec:
      hostPID: true
      containers:
        - name: kube-bench
          image: aquasec/kube-bench:latest
          command: ["kube-bench", "--benchmark", "eks-1.0"]
          volumeMounts:
            - name: var-lib-kubelet
              mountPath: /var/lib/kubelet
              readOnly: true
            - name: etc-systemd
              mountPath: /etc/systemd
              readOnly: true
            - name: etc-kubernetes
              mountPath: /etc/kubernetes
              readOnly: true
      restartPolicy: Never
      volumes:
        - name: var-lib-kubelet
          hostPath:
            path: "/var/lib/kubelet"
        - name: etc-systemd
          hostPath:
            path: "/etc/systemd"
        - name: etc-kubernetes
          hostPath:
            path: "/etc/kubernetes"
EOF

kubectl apply -f kube-bench.yaml && sleep 10

kubectl logs -f job.batch/kube-bench --all-containers=true | grep "\[FAIL" > temp.results
if [[ $(cat temp.results) ]]; then
  echo "kube-bench conformance results error:"
  cat temp.results
  exit 1
fi
rm temp.results

kubectl delete -f kube-bench.yaml



