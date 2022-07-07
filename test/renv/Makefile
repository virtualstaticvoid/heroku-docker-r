# default build target
all::

include ../../Makevars

PROJ:=$(shell basename $(CURDIR))
TEST_IMAGE:=$(IMAGE_TAG)-test-$(PROJ)

export

UID:=$(shell id -u)
GID:=$(shell id -g)
SITE_LIB:=$(shell mktemp -d)

all:: build
.PHONY: all build test

build:

	@rm -rf renv || true
	@rm renv.lock || true
	@rm .Rprofile || true

	docker run -it --rm --user "$(UID):$(GID)" \
		--volume "$(PWD):/app" \
		--volume "$(SITE_LIB):/app/R/site-library" \
		--env R_LIBS_SITE=/app/R/site-library \
		--env R_LIBS_USER=/app/R/site-library \
		--workdir=/app \
		r-base:$(R_VERSION) \
		/usr/bin/R --no-save --quiet -s --file=/app/setup.R

test:

	docker build \
		--build-arg BASE_IMAGE=$(IMAGE_TAG) \
		--tag $(TEST_IMAGE) \
		--file Dockerfile .

	docker run \
		--tty \
		--rm \
		$(TEST_IMAGE)
