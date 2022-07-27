FROM {{APP_DOCKER_IMAGE_OS_NAME}}

LABEL maintainer "{{MAINTAINER}}"

ENV OS_ARCH="amd64" \
    OS_NAME="{{APP_DOCKER_OS_NAME}}" \
    HOME_PAGE="{{APP_HOME}}"

COPY debian/prebuildfs /

ENV TZ=Asia/Shanghai \
    DEBIAN_FRONTEND=noninteractive

ARG IS_CHINA="true"
ENV MIRROR=${IS_CHINA}

RUN install_packages curl wget zip unzip s6 pwgen cron

# Install internal php
RUN . /opt/easysoft/scripts/libcomponent.sh && component_unpack "php" "7.4.28" -c 934dd0320ee217465f6a8496b0858d120c3fd45b413f1c9ff833731a848cefa7

# Install php-ext-ioncube
RUN . /opt/easysoft/scripts/libcomponent.sh && component_unpack "php-ext-ioncube" "11.0.1" -c 9a6ee08aa864f2b937b9a108d3ec8679ae3a5f08f92a36caf5280520432315ad

# Install apache
RUN . /opt/easysoft/scripts/libcomponent.sh && component_unpack "apache" "2.4.53-fix" -c 46142923f1e74406b6d2a2eb8ed6f61289f30607eaac3c3b9b1cb83c156fdb33

# Install su-exec
RUN . /opt/easysoft/scripts/libcomponent.sh && component_unpack "su-exec" "0.2" --checksum 687d29fd97482f493efec73a9103da232ef093b2936a341d85969bc9b9498910

# Install render-template
RUN . /opt/easysoft/scripts/libcomponent.sh && component_unpack "render-template" "1.0.1-10" --checksum 5e410e55497aa79a6a0c5408b69ad4247d31098bdb0853449f96197180ed65a4

# Install mysql-client
RUN . /opt/easysoft/scripts/libcomponent.sh && component_unpack "mysql-client" "10.5.15" -c 31182985daa1a2a959b5197b570961cdaacf3d4e58e59a192c610f8c8f1968a8

# Install wait-for-port
RUN . /opt/easysoft/scripts/libcomponent.sh && component_unpack "wait-for-port" "1.01" -c 2ad97310f0ecfbfac13480cabf3691238fdb3759289380262eb95f8660ebb8d1

# Install {{app_name}}
ARG VERSION
ENV APP_VER=${VERSION}
ENV EASYSOFT_APP_NAME="{{APP_NAME}} $APP_VER"

RUN . /opt/easysoft/scripts/libcomponent.sh && z_download "{{app_name}}" "${APP_VER}"

# Clear apahce vhost config
RUN rm -rf /etc/apache2/sites-available/* /etc/apache2/sites-enabled/*

# Copy {{app_name}} config files
COPY debian/rootfs /

# Copy {{app_name}} source code
WORKDIR /apps/{{app_name}}
RUN chown www-data.www-data /apps/{{app_name}} -R \
    && a2dismod authz_svn dav_svn

EXPOSE 80

# Persistence directory
VOLUME [ "/data"]

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
