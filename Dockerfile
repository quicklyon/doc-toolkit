FROM easysoft/debian:11

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
RUN . /opt/easysoft/scripts/libcomponent.sh && component_unpack "market-push" "0.1.1" --checksum a4312a872d69a37795fcbdc0b065363087f54734d00b57d88404451ac9ab938b

# Install helm
RUN . /opt/easysoft/scripts/libcomponent.sh && component_unpack "helm" "3.8.2" --checksum 89498f9ae484b598ec71565aaf392f9b132ed41e23396058850eb458f13419e0

ARG VERSION
ENV EASYSOFT_APP_NAME="Document-Toolkit $VERSION"

COPY rootfs /

# Copy templates to images
COPY templates  /templates

WORKDIR /quickon

CMD ["$@"]

