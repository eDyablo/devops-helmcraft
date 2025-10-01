set -e

mkdir -p ~/.aws && cp -r /opt/.aws ~/

mkdir -p ~/.kube && cp /opt/.kube/config ~/.kube/config
echo $KUBE_CLUSTER_SERVER_MAP | tr -s ';' '\n' | while read KUBE_CLUSTER KUBE_CLUSTER_SERVER; do
  ${KUBE_CLUSTER:+kubectl config set-cluster ${KUBE_CLUSTER} --server=${KUBE_CLUSTER_SERVER}}
done

PS1='${AWS_PROFILE:+"${AWS_PROFILE} "}$(kubectl config current-context) \w $ ' bash $@
