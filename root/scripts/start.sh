#!/usr/bin/env sh

if [ "x$GIT_REPO" != "x" ]; then
	cd $SERVICE_WORK
	git clone $GIT_REPO
fi

if [ -f "/workspace/.gitconfig" ]; then
	ln -s /workspace/.gitconfig /home/${USER}/.gitconfig
else
	touch /workspace/.gitconfig
	ln -s /workspace/.gitconfig /home/${USER}/.gitconfig
fi


chown -R ${USER}:${USER} /home/${USER}
chown -R ${USER}:${USER} /workspace

cd $SERVICE_HOME && /home/${USER}/.c9/node/bin/node server.js $@
