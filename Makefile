APP=$(shell basename $(shell git remote get-url origin))
REGISTRY=gcr.io/kbot-385713
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETOS=linux #linux darwin windows
TARGETARCH=amd64 #amd64 arm64
CGO_ENABLED=0

format:
	gofmt -s -w ./

lint:
	golint

test:
	go test -v

get:
	go get

build: format get
	CGO_ENABLED=${CGO_ENABLED} GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X=github.com/oleksiihead/kbot/cmd.appVersion=${VERSION}"

build_linux: format get
	CGO_ENABLED=${CGO_ENABLED} GOOS=linux GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X=github.com/oleksiihead/kbot/cmd.appVersion=${VERSION}"

build_macos: format get
	CGO_ENABLED=${CGO_ENABLED} GOOS=darwin GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X=github.com/oleksiihead/kbot/cmd.appVersion=${VERSION}"

build_windows: format get
	CGO_ENABLED=${CGO_ENABLED} GOOS=windows GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X=github.com/oleksiihead/kbot/cmd.appVersion=${VERSION}"

image:
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

image_linux:
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH} --build-arg TARGETOS=linux --build-arg TARGETARCH=${TARGETARCH}

image_macos:
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH} --build-arg TARGETOS=darwin --build-arg TARGETARCH=${TARGETARCH}

image_windows:
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH} --build-arg TARGETOS=windows --build-arg TARGETARCH=${TARGETARCH}

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

clean:
	rm -rf kbot
	docker rmi ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}
