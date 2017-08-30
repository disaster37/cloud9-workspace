#!/bin/sh

echo "############# INSTALL GOLANG #############"

cd /tmp
wget https://storage.googleapis.com/golang/go${GOLANG_VERSION}.linux-amd64.tar.gz
tar -xvf go${GOLANG_VERSION}.linux-amd64.tar.gz
mv go /usr/local
export PATH="/usr/local/go/bin:$PATH";
go version

GOPATH=$SERVICE_WORK/go
PATH=$GOPATH/bin:/usr/local/go/bin:$PATH

mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"