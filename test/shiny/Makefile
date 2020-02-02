# default build target
all::

all:: test
.PHONY: all test

PROJ=$(shell basename $(CURDIR))
TEST_IMAGE=$(IMAGE_TAG)-test-$(PROJ)

test:

	docker build \
		--build-arg BASE_IMAGE=$(IMAGE_TAG) \
		--tag $(TEST_IMAGE) \
		--file Dockerfile .

	$(eval CONTAINERID=$(shell docker run --detach --rm $(TEST_IMAGE)))

	docker exec --tty $(CONTAINERID) /bin/bash /app/test

	docker stop $(CONTAINERID)
