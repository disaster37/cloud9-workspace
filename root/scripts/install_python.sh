#!/bin/sh

apt-get update
apt-get install -y --no-install-recommends make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev llvm libncurses5-dev  libncursesw5-dev xz-utils tk-dev

cd /tmp
wget https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz
tar xvf Python-${PYTHON_VERSION}.tgz
rm -rf Python-${PYTHON_VERSION}.tgz
cd Python-${PYTHON_VERSION}
./configure --enable-optimizations
make -j8
sudo make altinstall
cd ..
rm -rf Python-${PYTHON_VERSION}

apt-get autoremove -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev llvm libncurses5-dev  libncursesw5-dev xz-utils tk-dev &&\
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*