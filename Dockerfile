FROM alpine:3.6
MAINTAINER Raul Sanchez <rawmind@gmail.com>

ENV SERVICE_HOME=/opt/cloud9 \
    SERVICE_URL=https://github.com/c9/core.git \
    SERVICE_WORK=/workspace \
    USER=dev \
    GROUP=dev \
    UID=1001 \
    GID=1001 \
    DOCKER_HOST=docker:2375 \
    GOPATH=/go \
    EMBER_VERSION=2.14.2 \
    DOCKER_COMPOSE_VERSION=1.15.0 \
    GOLANG_VERSION=1.8.3 \
    NODE_VERSION=6.11.2 \
    PYTHON_VERSION=3.6.2 \
    PYTHON_PIP_VERSION=9.0.1 \
    DOCKER_VERSION=17.06.1-ce \
    LANG=C.UTF-8 \
    PATH=/usr/local/bin:$GOPATH/bin:/usr/local/go/bin:$PATH



COPY root /
RUN \
    addgroup -g ${GID} ${GROUP} && \
    adduser -g "${USER} user" -D -G ${GROUP} -s /bin/bash -u ${UID} ${USER} &&\
    mkdir -p $SERVICE_HOME $SERVICE_WORK && \
    chown -R dev $SERVICE_WORK &&\
    chown -R dev $SERVICE_HOME

# Install devs require language and tools
RUN sh /tmp/install_golang.sh
RUN sh /tmp/install_node.sh
RUN sh /tmp/install_python.sh
RUN sh /tmp/install_docker.sh
RUN sh /tmp/install_gitflow.sh

# Install some usefull tools
RUN apk add --update curl openssh-client git vim sudo

# Install cloud9
USER dev
RUN \
    git clone $SERVICE_URL $SERVICE_HOME && \
    cd $SERVICE_HOME && \
    sh scripts/install-sdk.sh && \
    sed -i -e 's_127.0.0.1_0.0.0.0_g' $SERVICE_HOME/configs/standalone.js
USER root

# Clean image
RUN rm /tmp/* /var/cache/apk/*

RUN \
    echo "Go version: $(go version)" &&\
    echo "Node version: $(node --version)" &&\
    echo "NPM version: $(npm --version)" &&\
    echo "Python version: $(python --version)" &&\
    echo "Pip version: $(pip --version)" &&\
    echo "Docker version: $(docker -v)" &&\
    echo "Emberjs version: $(ember --version)"
    
RUN \
    chmod +x /tmp/*.sh &&\
    chmod -R 777 /tmp

USER dev

WORKDIR "$SERVICE_WORK"

EXPOSE 8080
VOLUME ["$SERVICE_WORK"]
ENTRYPOINT ["/tmp/start.sh"]
CMD ["--listen 0.0.0.0 -p 8080 -w $SERVICE_WORK"]