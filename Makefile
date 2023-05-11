APP =$(shell basename $(shell git remote get-url origin))
REGISTRY =gcr.io/kbot-385713
GO_BUILD =go build -v -o kbot -ldflags "-X"=github.com/oleksiihead/kbot/cmd.appVersion=
VERSION =$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
# TARGETOS can be: linux darwin windows
TARGETOS =linux
# TARGETARCH can be: amd64 arm64
TARGETARCH ?=amd64
CGO_ENABLED ?=0

.PHONY: all format lint test get build build_linux build_macos build_windows image image_linux image_macos image_windows push clean

all: format lint test build image push clean

format:
	gofmt -s -w ./

lint:
	golint

test:
	go test -v

get:
	go get

build: format get
	CGO_ENABLED=${CGO_ENABLED} GOOS=${TARGETOS} GOARCH=${TARGETARCH} ${GO_BUILD}${VERSION}

linux: format get
	CGO_ENABLED=${CGO_ENABLED} GOOS=linux GOARCH=${TARGETARCH} ${GO_BUILD}${VERSION}

macos: format get
	CGO_ENABLED=${CGO_ENABLED} GOOS=darwin GOARCH=${TARGETARCH} ${GO_BUILD}{VERSION}

windows: format get
	CGO_ENABLED=${CGO_ENABLED} GOOS=windows GOARCH=${TARGETARCH} ${GO_BUILD}${VERSION}

image:
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH}

image_linux:
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH} --build-arg TARGETOS=linux --build-arg TARGETARCH=${TARGETARCH} --build-arg CGO_ENABLED=0

image_macos:
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH} --build-arg TARGETOS=darwin --build-arg TARGETARCH=${TARGETARCH} --build-arg CGO_ENABLED=0

image_windows:
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH} --build-arg TARGETOS=windows --build-arg TARGETARCH=${TARGETARCH} --build-arg CGO_ENABLED=1

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH}

clean:
	rm -rf kbot
	docker rmi ${REGISTRY}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH}
