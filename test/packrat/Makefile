# default build target
all::

all:: test
.PHONY: all test

PROJ=$(shell basename $(CURDIR))
TEST_IMAGE=$(IMAGE_TAG)-test-$(PROJ)

test:

	docker build \
		--pull \
		--build-arg BASE_IMAGE=$(IMAGE_TAG) \
		--tag $(TEST_IMAGE) \
		--file Dockerfile .

	docker run \
		--rm \
		$(TEST_IMAGE)
