#!/usr/bin/env bash

set -euo pipefail

if [ -d "/opt/.ssh" ]; then
  cp -r "/opt/.ssh" "$HOME"
fi

if [ -d "/opt/.aws" ]; then
  cp -r "/opt/.aws" "$HOME"
fi

if [ -f "/opt/.kube/config" ]; then
  KUBE_CONFIG_FILE_PATH="$HOME/.kube/config"
  mkdir -p $(dirname "$KUBE_CONFIG_FILE_PATH")
  cp "/opt/.kube/config" "$KUBE_CONFIG_FILE_PATH"
fi

if [ -f "/opt/.sops/age/keys.txt" ]; then
  SOPS_AGE_KEYS_FILE_PATH="$HOME/.config/sops/age/keys.txt"
  mkdir -p $(dirname "$SOPS_AGE_KEYS_FILE_PATH")
  cp "/opt/.sops/age/keys.txt" "$SOPS_AGE_KEYS_FILE_PATH"
fi

echo $KUBE_CLUSTER_SERVER_MAP | tr -s ',' '\n' |
while read KUBE_CLUSTER_SERVER_MAPPING; do
  echo "$KUBE_CLUSTER_SERVER_MAPPING" | tr -s '=' ' ' | (
    read KUBE_CLUSTER KUBE_CLUSTER_SERVER
    ${KUBE_CLUSTER:+kubectl config set-cluster ${KUBE_CLUSTER} --insecure-skip-tls-verify=true --server=${KUBE_CLUSTER_SERVER}}
  )
done

PS1='${AWS_PROFILE:+"${AWS_PROFILE} "}$(kubectl config current-context) \w $ ' bash $@
