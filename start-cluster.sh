#!/bin/bash

set -euo pipefail

echo ""
echo "┌────────────────────────────────────────────┐"
echo "| -----------   SETUP CLUSTER    ----------- |"
echo "└────────────────────────────────────────────┘"
echo ""

echo "Creating cluster $DEMO_CONTAINERIZED_CLUSTER_NAME"
k3d cluster create "$DEMO_CONTAINERIZED_CLUSTER_NAME" --servers 1 --agents 2
# by default k3d adds a prefix to the context, we remove it
kubectl config rename-context "k3d-$DEMO_CONTAINERIZED_CLUSTER_NAME" "$DEMO_CONTAINERIZED_CLUSTER_NAME"
echo "Ok"

echo "Install the SCONE Operator in cluster '$DEMO_CONTAINERIZED_CLUSTER_NAME'..."
curl -fsSL "https://raw.githubusercontent.com/scontain/SH/master/$VERSION/operator_controller" |
bash -s - \
    --reconcile --update \
    --plugin \
    --secret-operator \
    --set-version "$VERSION" \
    --username "$SCONE_REGISTRY_USERNAME" \
    --access-token "$SCONE_REGISTRY_ACCESS_TOKEN" \
    --dcap-api "$DEMO_DCAP_API" \
    --email "$SCONE_REGISTRY_EMAIL"
echo "Ok"

echo "Deploy CAS in cluster '$DEMO_CONTAINERIZED_CLUSTER_NAME'..."
# the SCONE Operator installs the kubectl plugin `provision`, which we use to deploy CAS
kubectl provision cas "$CAS" --namespace "$CAS_NAMESPACE" --dcap-api "$DEMO_DCAP_API"
echo "Ok"
