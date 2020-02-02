SUBDIRS := $(wildcard */.)

test: $(SUBDIRS)

$(SUBDIRS):
	$(MAKE) -C $@

.PHONY: all test $(SUBDIRS)
