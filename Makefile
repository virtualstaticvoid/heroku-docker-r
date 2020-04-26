# default build target
all::

.PHONY: all
all:: build

HEROKU_VERSION:=18-build.v27
R_VERSION:=3.6.3

MAINTAINER:=Chris Stefano <virtualstaticvoid@gmail.com>
MAINTAINER_URL:=https://github.com/virtualstaticvoid/heroku-docker-r
IMAGE_NAME:=virtualstaticvoid/heroku-docker-r
IMAGE_TAG:=$(IMAGE_NAME):$(R_VERSION)
GIT_SHA:=$(shell git rev-parse HEAD)
GIT_DATE:=$(shell TZ=UTC git show --quiet --date='format-local:%Y-%m-%d %H:%M:%S +0000' --format='%cd')
BUILD_DATE:=$(shell date -u '+%Y-%m-%d %H:%M:%S %z')

export

.PHONY: build
build:

	# "base" image
	docker build \
		--pull \
		--build-arg HEROKU_VERSION=$(HEROKU_VERSION) \
		--build-arg R_VERSION=$(R_VERSION) \
		--label "heroku.version=$(HEROKU_VERSION)" \
		--label "r.version=$(R_VERSION)" \
		--label "git.sha=$(GIT_SHA)" \
		--label "git.date=$(GIT_DATE)" \
		--label "build.date=$(BUILD_DATE)" \
		--label "maintainer=$(MAINTAINER)" \
		--label "maintainer.url=$(MAINTAINER_URL)" \
		--label "build.logurl=$(TRAVIS_BUILD_WEB_URL)" \
		--tag $(IMAGE_TAG) \
		--tag $(IMAGE_NAME):latest \
		--file Dockerfile .

	# "build" image
	docker build \
		--build-arg BASE_IMAGE=$(IMAGE_TAG) \
		--tag $(IMAGE_TAG)-build \
		--tag $(IMAGE_NAME):build \
		--file Dockerfile.build .

	# "shiny" image
	docker build \
		--build-arg BASE_IMAGE=$(IMAGE_TAG) \
		--tag $(IMAGE_TAG)-shiny \
		--tag $(IMAGE_NAME):shiny \
		--file Dockerfile.shiny .

	# "plumber" image
	docker build \
		--build-arg BASE_IMAGE=$(IMAGE_TAG) \
		--tag $(IMAGE_TAG)-plumber \
		--tag $(IMAGE_NAME):plumber \
		--file Dockerfile.plumber .

.PHONY: test
test:

	# smoke test images, before running units
	docker run --rm $(IMAGE_TAG) R --no-save -e "capabilities()"
	docker run --rm $(IMAGE_TAG)-build R --no-save -e "capabilities()"
	docker run --rm $(IMAGE_TAG)-shiny R --no-save -e "capabilities()"
	docker run --rm $(IMAGE_TAG)-plumber R --no-save -e "capabilities()"

	# run units
	$(MAKE) -C test test

.PHONY: push
push:

	docker push $(IMAGE_NAME):latest
	docker push $(IMAGE_TAG)

	docker push $(IMAGE_NAME):build
	docker push $(IMAGE_TAG)-build

	docker push $(IMAGE_NAME):shiny
	docker push $(IMAGE_TAG)-shiny

	docker push $(IMAGE_NAME):plumber
	docker push $(IMAGE_TAG)-plumber
