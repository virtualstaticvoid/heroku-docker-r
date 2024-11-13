# default build target
all::

.PHONY: all
all:: build

include Makevars

export

.PHONY: build
build:
	# "base" image
	docker build \
		--pull \
		--build-arg UBUNTU_VERSION=$(UBUNTU_VERSION) \
		--build-arg R_VERSION=$(R_VERSION) \
		--build-arg CRAN_VERSION=$(CRAN_VERSION) \
		--label "r.version=$(R_VERSION)" \
		--label "git.sha=$(GIT_SHA)" \
		--label "maintainer=$(MAINTAINER)" \
		--label "maintainer.url=$(MAINTAINER_URL)" \
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
	docker run --tty --rm $(IMAGE_TAG) R --no-save -e "capabilities()"
	docker run --tty --rm $(IMAGE_TAG)-build R --no-save -e "capabilities()"
	docker run --tty --rm $(IMAGE_TAG)-shiny R --no-save -e "capabilities()"
	docker run --tty --rm $(IMAGE_TAG)-plumber R --no-save -e "capabilities()"

	# run units
	$(MAKE) -C test test

.PHONY: push
push:
	# image names contain R version
	docker push $(IMAGE_TAG)
	docker push $(IMAGE_TAG)-build
	docker push $(IMAGE_TAG)-shiny
	docker push $(IMAGE_TAG)-plumber

.PHONY: push-latest
push-latest:
	# images labelled as "latest"
	docker push $(IMAGE_NAME):latest
	docker push $(IMAGE_NAME):build
	docker push $(IMAGE_NAME):shiny
	docker push $(IMAGE_NAME):plumber

# adapted from https://stackoverflow.com/a/48782113/30521
env-%:
	@echo '$($*)'
