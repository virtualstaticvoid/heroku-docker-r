# default build target
all::

all:: test
.PHONY: all test

PROJ:=$(shell basename $(CURDIR))
TEST_IMAGE:=$(IMAGE_TAG)-test-$(PROJ)

export

test:

	docker build \
		--build-arg BASE_IMAGE=$(IMAGE_TAG) \
		--tag $(TEST_IMAGE) \
		--file Dockerfile .

	docker-compose up --detach

	docker-compose exec plumber /bin/bash /app/test

	docker-compose down
