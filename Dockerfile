FROM debian:stable-slim
MAINTAINER Disaster <linuxworkgroup@hotmail.com>

ENV SERVICE_HOME=/opt/cloud9 \
    SERVICE_URL=https://github.com/c9/core.git \
    SERVICE_WORK=/workspace \
    USER=dev \
    DOCKER_HOST=docker:2375 \
    GOPATH=/go \
    EMBER_VERSION=2.14.2 \
    DOCKER_COMPOSE_VERSION=1.15.0 \
    GOLANG_VERSION=1.8.3 \
    NODE_BRANCH=6.x \
    DOCKER_VERSION=17.06.1-ce \
    PYTHON_VERSION=3.6.2 \
    LANG=C.UTF-8 \
    PATH=/usr/local/bin:/go/bin:/usr/local/go/bin:$PATH



COPY root /
RUN \
    useradd -G sudo -m $USER &&\
    mkdir -p $SERVICE_HOME $SERVICE_WORK && \
    chown -R dev $SERVICE_WORK &&\
    chown -R dev $SERVICE_HOME

# Install required and some extra tools
RUN apt-get update &&\
    apt-get upgrade -y &&\
    apt-get install -y python build-essential g++ libssl-dev git libxml2-dev tmux &&\
    apt-get install -y wget bash curl vim sudo aptitude

# Install cloud9
USER $USER
RUN \
    git clone $SERVICE_URL $SERVICE_HOME && \
    cd $SERVICE_HOME && \
    scripts/install-sdk.sh && \
    sed -i -e 's_127.0.0.1_0.0.0.0_g' $SERVICE_HOME/configs/standalone.js
USER root

# Configure sudo and Clean image
RUN \
    echo "%sudo ALL = NOPASSWD : ALL" >> /etc/sudoers &&\
    apt-get autoremove -y python build-essential g++ libssl-dev git libxml2-dev &&\
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
    

# Install package for developer
RUN \
    sh /scripts/install_golang.sh &&\
    sh /scripts/install_docker.sh &&\
    sh /scripts/install_node.sh &&\
    sh /scripts/install_emberjs.sh &&\
    sh /scripts/install_gitflow.sh &&\
    sh /scripts/install_python.sh
    

RUN \
    echo "Go version: $(go version)" &&\
    echo "Node version: $(node --version)" &&\
    echo "NPM version: $(npm --version)" &&\
    echo "Docker version: $(docker -v)" &&\
    echo "Docker-compose version: $(docker-compose --version)" &&\
    echo "Emberjs version: $(ember --version)"
    echo "Python version: $(python3 --version)"
    echo "Pip version: $(pip3 --version)"
    
RUN \
    chmod +x /scripts/*.sh &&\
    chmod -R 777 /scripts

USER $USER

WORKDIR "$SERVICE_WORK"

EXPOSE 8080
VOLUME ["$SERVICE_WORK"]
ENTRYPOINT ["/scripts/start.sh"]
CMD ["--listen 0.0.0.0 -p 8080 -w $SERVICE_WORK"]