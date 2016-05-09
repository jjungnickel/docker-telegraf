FROM alpine:3.3
MAINTAINER Nicolas Degory <ndegory@axway.com>

RUN apk --no-cache add python && \
    apk --virtual envtpl-deps add --update py-pip python-dev curl && \
    curl https://bootstrap.pypa.io/ez_setup.py | python && \
    pip install envtpl && \
    apk del envtpl-deps

ENV TELEGRAF_VERSION 0.12.0
ENV INFLUXDB_URL http://localhost:8086
ENV INTERVAL 10s

RUN apk --virtual build-deps add go curl git gcc musl-dev make && \
    export GOPATH=/go && \
    go get github.com/influxdata/telegraf && \
    cd $GOPATH/src/github.com/influxdata/telegraf && \
    git checkout -q --detach "${TELEGRAF_VERSION}" && \
    echo -e "github.com/go-ini/ini HEAD\ngithub.com/jmespath/go-jmespath HEAD\ngithub.com/pmezard/go-difflib/difflib HEAD\ngithub.com/stretchr/objx HEAD\n" >> Godeps && \
    make && \
    chmod +x $GOPATH/bin/* && \
    mv $GOPATH/bin/* /bin/ && \
    apk del build-deps && \
    cd / && rm -rf /var/cache/apk/* $GOPATH && \
    mkdir -p /etc/telegraf

EXPOSE 8125/udp 8092/udp 8094

COPY telegraf.conf.tpl /etc/telegraf/telegraf.conf.tpl
COPY run.sh /run.sh
RUN chmod +x /run.sh

CMD [ "/run.sh" ]

# will be updated whenever there's a new commit
LABEL commit=${GIT_COMMIT}
LABEL branch=${GIT_BRANCH}
