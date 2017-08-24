#!/bin/sh


apk add --no-cache ca-certificates

set -eux;
apk add --no-cache --virtual .build-deps \
	bash \
	gcc \
	musl-dev \
	openssl \
	go \
	;

export \
    GOROOT_BOOTSTRAP="$(go env GOROOT)" \
	GOOS="$(go env GOOS)" \
	GOARCH="$(go env GOARCH)" \
	GO386="$(go env GO386)" \
	GOARM="$(go env GOARM)" \
	GOHOSTOS="$(go env GOHOSTOS)" \
	GOHOSTARCH="$(go env GOHOSTARCH)" \
    ;

wget -O go.tgz "https://golang.org/dl/go$GOLANG_VERSION.src.tar.gz";
echo '5f5dea2447e7dcfdc50fa6b94c512e58bfba5673c039259fd843f68829d99fa6 *go.tgz' | sha256sum -c -;
tar -C /usr/local -xzf go.tgz;
rm go.tgz;

cd /usr/local/go/src;
for p in /go-alpine-patches/*.patch; do
		[ -f "$p" ] || continue;
		patch -p2 -i "$p";
done;
echo "GO_BOOSTRAP: $GOROOT_BOOTSTRAP"
./make.bash;

rm -rf /go-alpine-patches;
apk del .build-deps;

export PATH="/usr/local/go/bin:$PATH";
go version

GOPATH=/go
PATH=$GOPATH/bin:/usr/local/go/bin:$PATH

mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"