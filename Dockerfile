# 
# json-schema utility image
# (c) 2018-2023 Roozbeh Farahbod, roozbeh.ca 
# https://github.com/roozbehf/docker-json-schema
#

FROM golang:1.19-alpine
LABEL maintainer="Roozbeh Farahbod, roozbeh.ca"

ARG JSONSCHEMA2POJO_VER=1.1.2
ARG JSONSCHEMA_CMD_JV_VER=v0.3.1

# --- Install command-line tools
RUN apk update && \
    apk add --no-cache \
    bash \
    git \
    openssh \
    tree \
    make \
    zip \
    bzip2 \
    unzip \
    yq 

# --- Install 'jv' from santhosh-tekuri/jsonschema
RUN go install github.com/santhosh-tekuri/jsonschema/cmd/jv@${JSONSCHEMA_CMD_JV_VER}
ENV PATH $GOPATH/bin:$PATH

# --- Install jsonschema2pojo
RUN mkdir /download && \
    cd /download && \
    wget https://github.com/joelittlejohn/jsonschema2pojo/releases/download/jsonschema2pojo-${JSONSCHEMA2POJO_VER}/jsonschema2pojo-${JSONSCHEMA2POJO_VER}.zip && \
    unzip jsonschema2pojo-${JSONSCHEMA2POJO_VER}.zip
RUN chmod +x /download/jsonschema2pojo-${JSONSCHEMA2POJO_VER}/bin/*
ENV PATH /download/jsonschema2pojo-${JSONSCHEMA2POJO_VER}/bin:$PATH

# --- Install gojsonschema
RUN go install github.com/atombender/go-jsonschema/cmd/gojsonschema@latest

COPY files/validate.sh /usr/bin/validate.sh
ENTRYPOINT ["/usr/bin/validate.sh"]
