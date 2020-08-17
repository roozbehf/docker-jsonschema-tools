#!/bin/bash
#
# Runs JSON schema validation tool using the remote docker image 
#
# Copyright (c) 2020, Roozbeh Farahbod
#

DOCKER_IMAGE=theroozbeh/json-schema:latest

docker run \
    --rm -it \
    --net="none" \
    -v `pwd`:/pg \
    -u `id -u` \
    ${DOCKER_IMAGE} "$@"
