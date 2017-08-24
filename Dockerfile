FROM alpine:3.6
MAINTAINER Raul Sanchez <rawmind@gmail.com>

ENV SERVICE_HOME=/opt/cloud9 \
    SERVICE_URL=https://github.com/c9/core.git \
    SERVICE_WORK=/workspace \
    DOCKER_HOST=docker:2375 \
    GOPATH=/go \
    EMBER_VERSION=2.14.2 \
    DOCKER_COMPOSE_VERSION=1.15.0 \
    GOLANG_VERSION=1.8.3 \
    NODE_VERSION=6.11.2 \
    PYTHON_VERSION=3.6.2 \
    PYTHON_PIP_VERSION=9.0.1 \
    LANG=C.UTF-8 \
    PATH=/usr/local/bin:$GOPATH/bin:/usr/local/go/bin:$PATH



COPY root /
RUN sh /tmp/install_golang.sh
RUN sh /tmp/install_node.sh
RUN sh /tmp/install_python.sh

RUN \
    go version &&\
    node --version &&\
    npm --version &&\
    python --version &&\
    pip --version