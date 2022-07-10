# default build target
all::

include ../../Makevars

PROJ:=$(shell basename $(CURDIR))
TEST_IMAGE:=$(IMAGE_TAG)-test-$(PROJ)

export

all:: test
.PHONY: all test

test:

	docker build \
		--build-arg BASE_IMAGE=$(IMAGE_TAG) \
		--tag $(TEST_IMAGE) \
		--file Dockerfile .

	docker compose up --detach

	docker compose exec -T $(PROJ) /bin/bash /app/test

	docker compose down
