# default build target
all::

all:: build
.PHONY: all

R_VERSION:=3.4.4
APT_VERSION:=3.4.4-1xenial0

MAINTAINER:="Chris Stefano <virtualstaticvoid@gmail.com>"
MAINTAINER_URL:="https://github.com/virtualstaticvoid/heroku-docker-r"
IMAGE_NAME:=virtualstaticvoid/heroku-docker-r
GIT_BRANCH:="$(shell git symbolic-ref --short HEAD)"
GIT_SHA:="$(shell git rev-parse HEAD)"
GIT_DATE:="$(shell TZ=UTC git show --quiet --date='format-local:%Y-%m-%d %H:%M:%S +0000' --format='%cd')"
BUILD_DATE:="$(shell date -u '+%Y-%m-%d %H:%M:%S %z')"

build:

	# "runtime" image
	docker build \
		--build-arg R_VERSION=$(R_VERSION) \
		--build-arg APT_VERSION=$(APT_VERSION) \
		--build-arg MAINTAINER=$(MAINTAINER) \
		--build-arg MAINTAINER_URL=$(MAINTAINER_URL) \
		--build-arg GIT_BRANCH=$(GIT_BRANCH) \
		--build-arg GIT_SHA=$(GIT_SHA) \
		--build-arg GIT_DATE=$(GIT_DATE) \
		--build-arg BUILD_DATE=$(BUILD_DATE) \
		--tag $(IMAGE_NAME):$(R_VERSION) \
		- < Dockerfile

	docker tag $(IMAGE_NAME):$(R_VERSION) $(IMAGE_NAME):latest

	# "build" image
	docker build \
		--build-arg R_VERSION=$(R_VERSION) \
		--build-arg APT_VERSION=$(APT_VERSION) \
		--build-arg MAINTAINER=$(MAINTAINER) \
		--build-arg MAINTAINER_URL=$(MAINTAINER_URL) \
		--build-arg GIT_BRANCH=$(GIT_BRANCH) \
		--build-arg GIT_SHA=$(GIT_SHA) \
		--build-arg GIT_DATE=$(GIT_DATE) \
		--build-arg BUILD_DATE=$(BUILD_DATE) \
		--tag $(IMAGE_NAME):$(R_VERSION)-build \
		- < Dockerfile.build

	docker tag $(IMAGE_NAME):$(R_VERSION)-build $(IMAGE_NAME):build

	# "build" image for shiny
	docker build \
		--build-arg R_VERSION=$(R_VERSION) \
		--build-arg APT_VERSION=$(APT_VERSION) \
		--build-arg MAINTAINER=$(MAINTAINER) \
		--build-arg MAINTAINER_URL=$(MAINTAINER_URL) \
		--build-arg GIT_BRANCH=$(GIT_BRANCH) \
		--build-arg GIT_SHA=$(GIT_SHA) \
		--build-arg GIT_DATE=$(GIT_DATE) \
		--build-arg BUILD_DATE=$(BUILD_DATE) \
		--tag $(IMAGE_NAME):$(R_VERSION)-shiny \
		- < Dockerfile.shiny

	docker tag $(IMAGE_NAME):$(R_VERSION)-shiny $(IMAGE_NAME):shiny

push:

	docker push $(IMAGE_NAME):latest
	docker push $(IMAGE_NAME):$(R_VERSION)

	docker push $(IMAGE_NAME):build
	docker push $(IMAGE_NAME):$(R_VERSION)-build

	docker push $(IMAGE_NAME):shiny
	docker push $(IMAGE_NAME):$(R_VERSION)-shiny
