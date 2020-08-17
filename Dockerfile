FROM golang:1.13.1-alpine3.10
LABEL maintainer="tooz technologies"

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
    unzip

# --- Install 'jv' from santhosh-tekuri/jsonschema
RUN go get -u github.com/santhosh-tekuri/jsonschema/cmd/jv
ENV PATH $GOPATH/bin:$PATH

# --- Install yaml2json
RUN go get github.com/bronze1man/yaml2json

# --- Install jsonschema2pojo
RUN mkdir /download && \
    cd /download && \
    wget https://github.com/joelittlejohn/jsonschema2pojo/releases/download/jsonschema2pojo-1.0.1/jsonschema2pojo-1.0.1.zip && \
    unzip jsonschema2pojo-1.0.1.zip
RUN chmod +x /download/jsonschema2pojo-1.0.1/bin/*
ENV PATH /download/jsonschema2pojo-1.0.1/bin:$PATH

# --- Install JSON Pretty Printer
RUN go get github.com/jmhodges/jsonpp

# --- Install NodeJS
RUN apk add nodejs nodejs-npm

RUN mkdir -p /pg

COPY files/validate.sh /usr/bin/validate.sh
ENTRYPOINT ["/usr/bin/validate.sh"]
