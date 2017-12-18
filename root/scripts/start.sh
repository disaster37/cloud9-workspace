#!/usr/bin/env sh

if [ "x$GIT_REPO" != "x" ]; then
	cd $SERVICE_WORK
	git clone $GIT_REPO
fi

# Manage git config
if [ -f "/workspace/.gitconfig" ]; then
	ln -s /workspace/.gitconfig /home/${SERVICE_USER}/.gitconfig
else
	touch /workspace/.gitconfig
	ln -s /workspace/.gitconfig /home/${SERVICE_USER}/.gitconfig
fi

# Manage cloud9 user setting
if [ -f "/workspace/.user.settings" ]; then
	rm /home/${SERVICE_USER}/.c9/user.settings
	ln -s /workspace/.user.settings /home/${SERVICE_USER}/.c9/user.settings
else
	mv /home/${SERVICE_USER}/.c9/user.settings /workspace/.user.settings
	ln -s /workspace/.user.settings /home/${SERVICE_USER}/.c9/user.settings
fi


chown -R ${SERVICE_USER}:${SERVICE_USER} /home/${SERVICE_USER}
chown -R ${SERVICE_USER}:${SERVICE_USER} /workspace

update-ca-certificates

su ${SERVICE_USER} -c "cd $SERVICE_HOME && /home/${SERVICE_USER}/.c9/node/bin/node server.js $@"
