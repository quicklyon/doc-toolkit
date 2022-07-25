FROM debian:11.4-slim

LABEL maintainer "zhouyueqiu <zhouyueqiu@easycorp.ltd>"

ENV OS_ARCH="amd64" \
    OS_NAME="debian-11" \
    HOME_PAGE="www.qucheng.com"

COPY prebuildfs /

ENV TZ=Asia/Shanghai \
    DEBIAN_FRONTEND=noninteractive \
    PATH=$PATH:/opt/easysoft/bin

RUN install_packages curl wget zip unzip pwgen apt-transport-https ca-certificates jq

# Install render-template
RUN . /opt/easysoft/scripts/libcomponent.sh && component_unpack "render-template" "1.0.1-10" --checksum 5e410e55497aa79a6a0c5408b69ad4247d31098bdb0853449f96197180ed65a4

ARG VERSION
ENV EASYSOFT_APP_NAME="Document-Toolkit $VERSION"

COPY rootfs /

WORKDIR /quickon

CMD ["$@"]

