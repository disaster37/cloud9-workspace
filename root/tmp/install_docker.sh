#!/bin/sh

apk add --no-cache \
		ca-certificates

DOCKER_CHANNEL=stable

# TODO ENV DOCKER_SHA256
# https://github.com/docker/docker-ce/blob/5b073ee2cf564edee5adca05eee574142f7627bb/components/packaging/static/hash_files !!
# (no SHA file artifacts on download.docker.com yet as of 2017-06-07 though)

set -ex;
# why we use "curl" instead of "wget":
# + wget -O docker.tgz https://download.docker.com/linux/static/stable/x86_64/docker-17.03.1-ce.tgz
# Connecting to download.docker.com (54.230.87.253:443)
# wget: error getting response: Connection reset by peer
apk add --no-cache --virtual .fetch-deps \
	curl \
	tar \
    ;
# this "case" statement is generated via "update.sh"
apkArch="$(apk --print-arch)"; \
case "$apkArch" in
	x86_64) dockerArch='x86_64' ;;
	s390x) dockerArch='s390x' ;;
	*) echo >&2 "error: unsupported architecture ($apkArch)"; exit 1 ;;
esac;

if ! curl -fL -o docker.tgz "https://download.docker.com/linux/static/${DOCKER_CHANNEL}/${dockerArch}/docker-${DOCKER_VERSION}.tgz"; then
	echo >&2 "error: failed to download 'docker-${DOCKER_VERSION}' from '${DOCKER_CHANNEL}' for '${dockerArch}'";
	exit 1;
fi;

tar --extract \
	--file docker.tgz \
	--strip-components 1 \
	--directory /usr/local/bin/ \
    ;
rm docker.tgz;

# Install docker compose
curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

apk del .fetch-deps; 

dockerd -v;
docker -v


