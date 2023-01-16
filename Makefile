#
# Makefile for the docker image
#
# Copyright (c) 2016-2023 Roozbeh Farahbod
#

.DEFAULT_GOAL:=build

# --- Load image name and version
IMAGE_NAME=$(shell grep IMAGE MANIFEST | cut -d '=' -f2)
VERSION=$(shell grep VERSION MANIFEST | cut -d '=' -f2)

REGISTRY=theroozbeh

# --- Capturing REMOTE vs LOCAL runs (will be removed once we have the CI in place)
TAG_LOCAL=local
TAG_REMOTE=$(VERSION)

CONFIG=
REMOTE ?= no

ifeq "$(REMOTE)" "yes"
	PUSH_CONFIRM=$(CONFIRM)
	TAG=$(TAG_REMOTE)
	FULL_IMAGE_NAME=$(REGISTRY)/$(IMAGE_NAME)
else
	PUSH_CONFIRM=no
	TAG=$(TAG_LOCAL)
	FULL_IMAGE_NAME=$(IMAGE_NAME)
endif

# --- Common Targets

# make sure test, build, and clean do not refer to files or folders
.PHONY: report destroy test build clean

# make sure the targets are executed sequentially
.NOTPARALLEL:

# report the current settings
report:
	@echo Image Name: $(IMAGE_NAME)
	@echo Version: $(VERSION)

# stop instances
stop:
	docker ps -a -q --filter ancestor=$(FULL_IMAGE_NAME) | xargs -r echo | xargs -r docker stop

# stop and remove instances
destroy: stop
	docker ps -a -q --filter ancestor=$(FULL_IMAGE_NAME) | xargs -r echo | xargs -r docker rm

# builds a docker image
build: 
	docker build --pull --force-rm --tag $(IMAGE_NAME)\:$(TAG) .

# tests the image
test: build
	docker run \
    	--rm -it \
    	--net="none" \
    	-v `pwd`:/pg \
    	-u `id -u` \
    	$(IMAGE_NAME)\:$(TAG) test/schema/event.yml test/event-object-pass.json

push: build
ifeq "$(PUSH_CONFIRM)" "yes"
	docker tag $(IMAGE_NAME)\:$(TAG) $(FULL_IMAGE_NAME)\:$(TAG)
	docker tag $(IMAGE_NAME)\:$(TAG) $(FULL_IMAGE_NAME)\:latest
	docker push $(FULL_IMAGE_NAME)\:$(TAG)
	docker push $(FULL_IMAGE_NAME)\:latest
else
	@echo
	@echo "!! SKIPPED. Use 'make push REMOTE=yes CONFIRM=yes'."
endif
