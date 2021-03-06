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
	rm -rf /home/${SERVICE_USER}/.gitconfig
	ln -s /workspace/.cloud9/.gitconfig /home/${SERVICE_USER}/.gitconfig
else
	touch /workspace/.cloud9/.gitconfig
	ln -s /workspace/.cloud9/.gitconfig /home/${SERVICE_USER}/.gitconfig
fi

# Manage docker config
if [ -d "/workspace/.cloud9/.docker" ]; then
	rm -rf /home/${SERVICE_USER}/.docker
	ln -s /workspace/.cloud9/.docker /home/${SERVICE_USER}/.docker
else
	mkdir /workspace/.cloud9/.docker
	ln -s /workspace/.cloud9/.docker /home/${SERVICE_USER}/.docker
fi

# Manage bashrc
if [ -f "/workspace/.cloud9/.bashrc" ]; then
	rm -rf /home/${SERVICE_USER}/.bashrc
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
	mkdir /workspace/.cloud9/.ssh
	ssh-keygen -b 2048 -t rsa -f /workspace/.cloud9/.ssh/id_rsa -q -N ""
	rm -rf /home/${SERVICE_USER}/.ssh
	ln -s /workspace/.cloud9/.ssh /home/${SERVICE_USER}/.ssh
fi



#chown -R ${SERVICE_USER}:${SERVICE_USER} /home/${SERVICE_USER}
chown -R ${SERVICE_USER}:${SERVICE_USER} /workspace

update-ca-certificates

su ${SERVICE_USER} -c "cd $SERVICE_HOME && /home/${SERVICE_USER}/.c9/node/bin/node server.js $@"
