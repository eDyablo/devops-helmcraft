ARG CONTAINER_IMAGE_REGISTRY

FROM ${CONTAINER_IMAGE_REGISTRY:+${CONTAINER_IMAGE_REGISTRY}/}alpine:3.22.1

RUN true \
  && echo '@community https://dl-cdn.alpinelinux.org/alpine/edge/community' >> /etc/apk/repositories \
  && echo '@main https://dl-cdn.alpinelinux.org/alpine/edge/main' >> /etc/apk/repositories \
  && echo '@testing https://dl-cdn.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories \
  && apk add --no-cache --update \
    aws-cli~=2.27 \
    bash~=5.2 \
    curl~=8.14 \
    git~=2.49 \
    go-task~=3.43 \
    jq~=1.8 \
    k9s~=0.50 \
    openssh~=10.0 \
    openssl~=3.5 \
    yq~=4.47 \
  && true

ENV HELM_VERSION=v3.19.0
ENV HELMFILE_VERSION=v1.1.7
ENV KUBECTL_VERSION=v1.34.1
ENV KUBESEAL_VERSION=0.32.2
ENV KUSTOMIZE_VERSION=5.7.1

RUN true \
  && OS_NAME=$(uname -o | tr '[:upper:]' '[:lower:]') \
    && ARCH_NAME=$(uname -m) \
      && ARCH_NAME=${ARCH_NAME/aarch64/arm64} \
      && ARCH_NAME=${ARCH_NAME/x86_64/amd64} \
  && curl -fL "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/${OS_NAME}/${ARCH_NAME}/kubectl" \
      --output /usr/local/bin/kubectl \
      --no-progress-meter \
    && chmod +x /usr/local/bin/kubectl \
  && curl -fSL "https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3" \
      --output get_helm.sh \
      --no-progress-meter \
    && chmod 700 get_helm.sh \
    && ./get_helm.sh --version ${HELM_VERSION} \
  && curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" \
      | bash -s - ${KUSTOMIZE_VERSION} \
    && mv ./kustomize /usr/local/bin \
  && mkdir -p helmfile \
    && curl -fL "https://github.com/helmfile/helmfile/releases/download/${HELMFILE_VERSION}/helmfile_${HELMFILE_VERSION/v/}_${OS_NAME}_${ARCH_NAME}.tar.gz" \
      --no-progress-meter \
      | tar xz -C helmfile \
    && mv helmfile/helmfile /usr/local/bin/helmfile \
      && chmod +x /usr/local/bin/helmfile \
      && rm -rf helmfile \
  && curl -sOL "https://github.com/bitnami-labs/sealed-secrets/releases/download/v${KUBESEAL_VERSION:?}/kubeseal-${KUBESEAL_VERSION:?}-linux-${ARCH_NAME}.tar.gz" \
    && tar -xvzf kubeseal-${KUBESEAL_VERSION:?}-linux-${ARCH_NAME}.tar.gz kubeseal \
    && install -m 755 kubeseal /usr/local/bin/kubeseal \
  && true

COPY entrypoint.sh /var/terminal/entrypoint.sh

RUN chmod a=rx /var/terminal/entrypoint.sh

ARG CONTAINER_USER=default
ARG CONTAINER_USER_GROUP=default

RUN addgroup -S ${CONTAINER_USER_GROUP} \
  && adduser -S ${CONTAINER_USER} -G ${CONTAINER_USER_GROUP}

USER ${CONTAINER_USER}:${CONTAINER_USER_GROUP}

RUN helmfile init --force

ENTRYPOINT [ "sh", "/var/terminal/entrypoint.sh" ]
