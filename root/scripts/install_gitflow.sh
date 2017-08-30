#!/bin/sh

apk add --no-cache --virtual .fetch-deps \
	curl \
    ;

curl -LO https://raw.github.com/petervanderdoes/gitflow-avh/develop/contrib/gitflow-installer.sh
sh gitflow-installer.sh install stable
rm gitflow-installer.sh

apk del .fetch-deps;