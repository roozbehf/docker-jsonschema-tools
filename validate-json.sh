#!/bin/bash
#
# Runs JSON schema validation tool using the remote docker image 
#
# Copyright (c) 2020-2023, Roozbeh Farahbod
#

DOCKER_IMAGE=theroozbeh/json-schema:latest
# DOCKER_IMAGE=json-schema:local

docker run \
    --rm -it \
    --net="none" \
    -v `pwd`:/pg \
    -u `id -u` \
    ${DOCKER_IMAGE} "$@"
