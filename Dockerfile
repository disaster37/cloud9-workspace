FROM node:7-slim
MAINTAINER Raul Sanchez <rawmind@gmail.com>

ENV SERVICE_HOME=/opt/cloud9 \
    SERVICE_URL=https://github.com/c9/core.git \
    SERVICE_WORK=/workspace

RUN mkdir -p $SERVICE_HOME $SERVICE_WORK && \
    apt-get update && \
    apt-get install -y python build-essential g++ libssl-dev apache2-utils git libxml2-dev && \
    git clone $SERVICE_URL $SERVICE_HOME && \
    cd $SERVICE_HOME && \
    scripts/install-sdk.sh && \
    sed -i -e 's_127.0.0.1_0.0.0.0_g' $SERVICE_HOME/configs/standalone.js && \
    apt-get autoremove -y python build-essential libssl-dev g++ libxml2-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install workspace requirement
RUN \
    apt-get update && \
    apt-get install openjdk-7-jdk gradle maven &&\
    apt-get install golang &&\
    apt-get install python3-all &&\
    apt-get install bzip2 &&\
    npm install -g async watchman bower phantomjs-prebuilt ember-cli gulp grunt-cli gulp-cli yo generator-angular-fullstack && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*



ADD root /
RUN chmod +x /tmp/*.sh

WORKDIR $SERVICE_WORK

EXPOSE 8080

ENTRYPOINT ["/tmp/start.sh"]
CMD ["--listen 0.0.0.0 -p 8080 -w $SERVICE_WORK"]
