FROM alpine:3.3
MAINTAINER Nicolas Degory <ndegory@axway.com>

RUN apk --no-cache add python py-pip python-dev curl && \
    curl https://bitbucket.org/pypa/setuptools/raw/bootstrap/ez_setup.py | python && \
    pip install envtpl && \
    apk del py-pip python-dev curl openssl ca-certificates libssh2 libbz2 expat libffi gdbm

ENV TELEGRAF_VERSION 0.12.0
ENV INFLUXDB_URL http://localhost:8086
ENV INTERVAL 10s

RUN export GOPATH=/go && \
    apk --no-cache add go git gcc musl-dev make && \
    go get github.com/influxdata/telegraf && \
    cd $GOPATH/src/github.com/influxdata/telegraf && \
    git checkout -q --detach "${TELEGRAF_VERSION}" && \
    echo -e "github.com/go-ini/ini HEAD\ngithub.com/jmespath/go-jmespath HEAD\ngithub.com/pmezard/go-difflib/difflib HEAD\ngithub.com/stretchr/objx HEAD\n" >> Godeps && \
    make && \
    chmod +x $GOPATH/bin/* && \
    mv $GOPATH/bin/* /bin/ && \
    apk del go git gcc musl-dev make binutils-libs binutils libatomic libgcc openssl libssh2 libstdc++ mpc1 isl gmp ca-certificates pkgconf pkgconfig mpfr3 && \
    rm -rf /var/cache/apk/* $GOPATH && \
    mkdir -p /etc/telegraf

EXPOSE 8125/udp 8092/udp 8094

COPY telegraf.conf.${TELEGRAF_VERSION}.tpl /etc/telegraf/telegraf.conf.tpl
COPY run.sh /run.sh
RUN chmod +x /run.sh

CMD [ "/run.sh" ]
