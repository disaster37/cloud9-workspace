FROM node:6-slim
MAINTAINER Raul Sanchez <rawmind@gmail.com>

ENV SERVICE_HOME=/opt/cloud9 \
    SERVICE_URL=https://github.com/c9/core.git \
    SERVICE_WORK=/workspace \
    DOCKER_HOST=docker:2375 \
    GOPATH=/go \
    EMBER_VERSION=2.14.2 \
    DOCKER_COMPOSE_VERSION=1.15.0

RUN \
    useradd -G sudo -m dev &&\
    mkdir -p $SERVICE_HOME $SERVICE_WORK && \
    mkdir -p /go && \
    chmod -R 777 /go &&\
    chown -R dev $SERVICE_WORK &&\
    chown -R dev $SERVICE_HOME &&\
    apt-get update && \
    apt-get install -y python build-essential g++ libssl-dev apache2-utils git libxml2-dev

USER dev

RUN \
    export HOME=$SERVICE_HOME &&\
    git clone $SERVICE_URL $SERVICE_HOME && \
    cd $SERVICE_HOME && \
    scripts/install-sdk.sh && \
    sed -i -e 's_127.0.0.1_0.0.0.0_g' $SERVICE_HOME/configs/standalone.js

USER root
RUN \
    apt-get autoremove -y python build-essential libssl-dev g++ libxml2-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install workspace requirement
RUN \
    echo "deb http://deb.debian.org/debian jessie-backports main" >> /etc/apt/sources.list &&\
    apt-get update && \
    apt-get -t jessie-backports install -y openjdk-8-jdk gradle maven &&\
    apt-get -t jessie-backports install -y  golang &&\
    apt-get -t jessie-backports install -y  git-flow &&\
    apt-get install -y python3-all python3-pip python-pip &&\
    apt-get install -y bzip2 sudo aptitude vim &&\
    apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common &&\
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add - &&\
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" &&\
    apt-get update &&\
    apt-get install -y docker-ce &&\
    echo "%sudo ALL = NOPASSWD : ALL" >> /etc/sudoers &&\
    npm install -g async watchman bower phantomjs-prebuilt silent-error esprima-fb ember-cli@${EMBER_VERSION} gulp grunt-cli gulp-cli yo generator-angular-fullstack && \
    curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose &&\
    chmod +x /usr/local/bin/docker-compose &&\
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV JAVA_HOME "/usr/lib/jvm/java-8-openjdk-amd64"
ADD root /
RUN \
    chmod +x /tmp/*.sh &&\
    chmod -R 777 /tmp

USER dev

WORKDIR "$SERVICE_WORK"

EXPOSE 8080
VOLUME ["$SERVICE_WORK"]
ENTRYPOINT ["/tmp/start.sh"]
CMD ["--listen 0.0.0.0 -p 8080 -w $SERVICE_WORK"]
