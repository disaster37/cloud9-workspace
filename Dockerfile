FROM node:4-slim
MAINTAINER Raul Sanchez <rawmind@gmail.com>

ENV SERVICE_HOME=/opt/cloud9 \
    SERVICE_URL=https://github.com/c9/core.git \
    SERVICE_WORK=/workspace

RUN \
    useradd -G sudo -m dev &&\
    mkdir -p $SERVICE_HOME $SERVICE_WORK && \
    chown -R dev $SERVICE_WORK &&\
    chown -R dev $SERVICE_HOME &&\
    apt-get update && \
    apt-get install -y python build-essential g++ libssl-dev apache2-utils git libxml2-dev

USER dev

RUN \
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
    apt-get install -y python3-all &&\
    apt-get install -y bzip2 sudo &&\
    echo "%sudo ALL = NOPASSWD : ALL" >> /etc/sudoers &&\
    npm install -g async watchman bower phantomjs-prebuilt ember-cli gulp grunt-cli gulp-cli yo generator-angular-fullstack && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


ADD root /
RUN chmod +x /tmp/*.sh

USER dev

WORKDIR $SERVICE_WORK

EXPOSE 8080

ENTRYPOINT ["/tmp/start.sh"]
CMD ["--listen 0.0.0.0 -p 8080 -w $SERVICE_WORK"]
