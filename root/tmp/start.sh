#!/usr/bin/env sh

if [ "x$GIT_REPO" != "x" ]; then
	cd $SERVICE_WORK
	git clone $GIT_REPO
fi

chown -R dev:dev /home/dev

cd $SERVICE_HOME && /usr/local/bin/node server.js $@
