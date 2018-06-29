#!/usr/bin/env sh

if [ "x$GIT_REPO" != "x" ]; then
	cd $SERVICE_WORK
	git clone $GIT_REPO
fi

# Manage internal settings
if [ ! -d "/workspace/.cloud9" ]; then
	mkdir /workspace/.cloud9
fi

# Manage git config
if [ -f "/workspace/.cloud9/.gitconfig" ]; then
	ln -s /workspace/.cloud9/.gitconfig /home/${SERVICE_USER}/.gitconfig
else
	touch /workspace/.cloud9/.gitconfig
	ln -s /workspace/.cloud9/.gitconfig /home/${SERVICE_USER}/.gitconfig
fi

# Manage docker config
if [ -d "/workspace/.cloud9/.docker" ]; then
	ln -s /workspace/.cloud9/.docker /home/${SERVICE_USER}/.docker
else
	mkdir /workspace/.cloud9/.docker
	ln -s /workspace/.cloud9/.docker /home/${SERVICE_USER}/.docker
fi

# Manage bashrc
if [ -f "/workspace/.cloud9/.bashrc" ]; then
	rm /home/${SERVICE_USER}/.bashrc
	ln -s /workspace/.cloud9/.bashrc /home/${SERVICE_USER}/.bashrc
else
	mv /home/${SERVICE_USER}/.bashrc /workspace/.cloud9/.bashrc
	ln -s /workspace/.cloud9/.bashrc /home/${SERVICE_USER}/.bashrc
fi

# Manage ssh key for git
if [ -d "/workspace/.cloud9/.ssh" ]; then
	rm -rf /home/${SERVICE_USER}/.ssh
	ln -s /workspace/.cloud9/.ssh /home/${SERVICE_USER}/.ssh
else
	ssh-keygen -b 2048 -t rsa -f /workspace/.cloud9/.ssh -q -N ""
	rm -rf /home/${SERVICE_USER}/.ssh
	ln -s /workspace/.cloud9/.ssh /home/${SERVICE_USER}/.ssh
fi

# Manage cloud9 user setting
if [ -f "/workspace/.cloud9/.user.settings" ]; then
	rm /home/${SERVICE_USER}/.c9/user.settings
	ln -s /workspace/.cloud9/.user.settings /home/${SERVICE_USER}/.c9/user.settings
else
	mv /home/${SERVICE_USER}/.c9/user.settings /workspace/.cloud9/.user.settings
	ln -s /workspace/.cloud9/.user.settings /home/${SERVICE_USER}/.c9/user.settings
fi


chown -R ${SERVICE_USER}:${SERVICE_USER} /home/${SERVICE_USER}
chown -R ${SERVICE_USER}:${SERVICE_USER} /workspace

update-ca-certificates

su ${SERVICE_USER} -c "cd $SERVICE_HOME && /home/${SERVICE_USER}/.c9/node/bin/node server.js $@"
