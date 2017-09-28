#!/usr/bin/env sh

if [ "x$GIT_REPO" != "x" ]; then
	cd $SERVICE_WORK
	git clone $GIT_REPO
fi

if [ -f "/workspace/.gitconfig" ]; then
	ln -s /workspace/.gitconfig /home/${SERVICE_USER}/.gitconfig
else
	touch /workspace/.gitconfig
	ln -s /workspace/.gitconfig /home/${SERVICE_USER}/.gitconfig
fi


chown -R ${SERVICE_USER}:${SERVICE_USER} /home/${SERVICE_USER}
chown -R ${SERVICE_USER}:${SERVICE_USER} /workspace

su - ${SERVICE_USER} -c "cd $SERVICE_HOME && /home/${SERVICE_USER}/.c9/node/bin/node server.js $@"
