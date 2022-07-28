FROM debian:11.4-slim

LABEL maintainer "zhouyueqiu <zhouyueqiu@easycorp.ltd>"

ENV OS_ARCH="amd64" \
    OS_NAME="debian-11" \
    HOME_PAGE="www.qucheng.com"

COPY prebuildfs /

ENV TZ=Asia/Shanghai \
    LANG=en_US.UTF-8

ARG IS_CHINA="true"
ENV MIRROR=${IS_CHINA}

RUN install_packages vim-tiny curl wget zip unzip pwgen apt-transport-https ca-certificates jq

# Install render-template
RUN . /opt/easysoft/scripts/libcomponent.sh && component_unpack "render-template" "1.0.1-10" --checksum 5e410e55497aa79a6a0c5408b69ad4247d31098bdb0853449f96197180ed65a4

# Install yq
RUN . /opt/easysoft/scripts/libcomponent.sh && component_unpack "yq" "4.25.3" --checksum d3e1e504d95c6ba82031474205e963aabd9f7bb9a26f2febb9a4837f1c494545

# Install market-push
RUN . /opt/easysoft/scripts/libcomponent.sh && component_unpack "market-push" "0.0.1" --checksum 122c25707ac862b765c21d277ee28ab6df2ee5c5147a1171d192c55de63954c5


ARG VERSION
ENV EASYSOFT_APP_NAME="Document-Toolkit $VERSION"

COPY rootfs /

# Copy templates to images
COPY templates  /templates

WORKDIR /quickon

CMD ["$@"]

