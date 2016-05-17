FROM alpine:3.3
MAINTAINER Nicolas Degory <ndegory@axway.com>

#need curl and bash available after install for containerPilot
RUN apk update && \
    apk --no-cache add python ca-certificates curl bash && \
    apk --virtual envtpl-deps add --update py-pip python-dev && \
    curl https://bootstrap.pypa.io/ez_setup.py | python && \
    pip install envtpl && \
    apk del envtpl-deps && rm -rf /var/cache/apk/*

ENV TELEGRAF_VERSION 0.13.0

RUN echo "http://nl.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories && \
    echo "http://nl.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    apk update && apk upgrade && \
    apk --virtual build-deps add go>1.6 curl git gcc musl-dev make && \
    export GOPATH=/go && \
    go get -v github.com/influxdata/telegraf && \
    cd $GOPATH/src/github.com/influxdata/telegraf && \
    git checkout -q --detach "${TELEGRAF_VERSION}" && \
    make && \
    chmod +x $GOPATH/bin/* && \
    mv $GOPATH/bin/* /bin/ && \
    apk del build-deps && \
    cd / && rm -rf /var/cache/apk/* $GOPATH && \
    mkdir -p /etc/telegraf

EXPOSE 8125/udp 8092/udp 8094

ENV INFLUXDB_URL http://localhost:8086
ENV INTERVAL 10s
ENV OUTPUT_INFLUXDB_ENABLED     true
ENV OUTPUT_CLOUDWATCH_ENABLED   false
ENV OUTPUT_KAFKA_ENABLED        false

COPY telegraf.conf.tpl /etc/telegraf/telegraf.conf.tpl

# Add ContainerPilot
RUN curl -Lo /tmp/cb.tar.gz https://github.com/joyent/containerpilot/releases/download/2.1.0/containerpilot-2.1.0.tar.gz \
&& tar -xz -f /tmp/cb.tar.gz \
&& mv ./containerpilot /bin/
COPY containerpilot.json /etc/containerpilot.json
COPY start.sh /start.sh
COPY stop.sh /stop.sh
RUN chmod +x /start.sh /stop.sh

ENV CONSUL=consul:8500
ENV CONTAINERPILOT=file:///etc/containerpilot.json
ENV DEPENDENCIES=influxdb

CMD ["sh", "-c", "/start.sh"]

LABEL axway_image=telegraf
# will be updated whenever there's a new commit
LABEL commit=${GIT_COMMIT}
LABEL branch=${GIT_BRANCH}
