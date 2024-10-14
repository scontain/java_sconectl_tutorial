FROM docker:23.0-dind

# Install utilities
RUN apk add --no-cache grep py3-pip bash coreutils jq curl gettext ruby git tar zstd binutils xz && \
    apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing && \
    gem install fpm && \
    curl -O -L "https://github.com/sigstore/cosign/releases/latest/download/cosign-linux-amd64" && \
    mv cosign-linux-amd64 /usr/local/bin/cosign && \
    chmod +x /usr/local/bin/cosign

# Install k3d, kubectl, and helm
ARG KUBECTL_VERSION="v1.28.10"
ARG K3D_VERSION="v5.7.3"

RUN curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | TAG=${K3D_VERSION} bash && \
    curl -LO https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl && \
    curl -LO https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl.sha256 && \
    echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check && \
    chmod +x kubectl && \
    mv ./kubectl /usr/local/bin/ && \
    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
