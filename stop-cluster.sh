#!/bin/bash

set -euo pipefail

echo ""
echo "┌────────────────────────────────────────────┐"
echo "| -----------    STOP CLUSTER    ----------- |"
echo "└────────────────────────────────────────────┘"
echo ""

echo "Stopping cluster $DEMO_CONTAINERIZED_CLUSTER_NAME..."
k3d cluster delete "$DEMO_CONTAINERIZED_CLUSTER_NAME"
# remove the modified, by the `start-clusters.sh`, context
kubectl config delete-context "$DEMO_CONTAINERIZED_CLUSTER_NAME"
echo "Ok"
