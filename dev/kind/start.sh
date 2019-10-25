#!/usr/bin/env bash

set -o errexit -o nounset

function cluster_exists {
  "${KIND}" get clusters | awk "/^${CLUSTER_NAME}\$/{ rc = 1 }; END { exit !rc }"
  return $?
}

# Create the cluster.
if ! cluster_exists; then
  "${KIND}" create cluster --name "${CLUSTER_NAME}"
else
  echo "Kind is already started"
fi

# Use the kubeconfig file generated by kind.
KUBECONFIG="$("${KIND}" get kubeconfig-path --name "${CLUSTER_NAME}")"
export KUBECONFIG

# Create a storage class.
"${KUBECTL}" apply --filename https://raw.githubusercontent.com/rancher/local-path-provisioner/master/deploy/local-path-storage.yaml
"${KUBECTL}" patch storageclass standard \
  --patch '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"false", "storageclass.beta.kubernetes.io/is-default-class":"false"}}}'
"${KUBECTL}" patch storageclass local-path \
  --patch '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true", "storageclass.beta.kubernetes.io/is-default-class":"true"}}}'

# Deploy the kube dashboard.
"${KUBECTL}" apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta1/aio/deploy/recommended.yaml

# Create the metrics server.
"${KUBECTL}" apply -f "${METRICS_SERVER}"

# Make the node trust Kube's CA.
docker exec "${CLUSTER_NAME}-control-plane" bash -c "cp /etc/kubernetes/pki/ca.crt /usr/local/share/ca-certificates/kube-ca.crt;update-ca-certificates;service containerd restart"

echo ""
echo "Set your KUBECONFIG by running:"
echo "export KUBECONFIG=\"\$(bazel run @kind//:kind -- get kubeconfig-path --name=\"scf\")\""
