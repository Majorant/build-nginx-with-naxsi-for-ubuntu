ARG BASE_IMAGE="ubuntu:xenial"

FROM ${BASE_IMAGE}

ARG NGINX_PPA="ppa:nginx/stable"
ARG NAXSI_VERSION="0.56"
ARG NGINX_BUILD_VERSION="101.16"

LABEL description="Image to build Ubuntu packages of Nginx with Naxsi WAF"
LABEL maintainer="Pavel Selivanov(https://github.com/selivan)"

# install apt packages necessary for build
RUN apt update && \
    apt install --install-recommends=no --yes software-properties-common && \
    apt-add-repository --enable-source --yes ${NGINX_PPA} && \
    apt update && \
    apt dist-upgrade --yes && \
    apt build-dep --yes nginx && \
    apt install --yes curl

# DEBUG
#RUN apt install --yes mc vim tmux less

VOLUME [ "/opt" ]

ADD run.sh /root/run.sh
RUN chmod a+x /root/run.sh && \
    echo "NAXSI_VERSION=${NAXSI_VERSION}" >> /root/run-cfg.sh && \
    echo "NGINX_BUILD_VERSION=${NGINX_BUILD_VERSION}" >> /root/run-cfg.sh

WORKDIR /root
ENTRYPOINT ["/root/run.sh"]
