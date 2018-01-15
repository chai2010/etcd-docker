# Copyright 2017 <chaishushan{AT}gmail.com>. All rights reserved.
# Use of this source code is governed by a BSD license
# that can be found in the LICENSE file.

# https://coreos.com/etcd/docs/latest/op-guide/container.html#docker
# https://coreos.com/etcd/docs/latest/v2/api.html

FROM golang:1.9.2-alpine3.6 as builder

RUN apk add --no-cache curl openssl

WORKDIR /go/src/github.com/chai2010/etcd-docker/
COPY . .

# install ./myapp
RUN go install ./myapp

# download etcd-v3.2.12
RUN mkdir -p /etcd-download && cd /etcd-download \
	&& curl -L https://github.com/coreos/etcd/releases/download/v3.2.12/etcd-v3.2.12-linux-amd64.tar.gz | tar zx

# download confd-v0.14.0.zip
RUN mkdir -p /confd-source && cd /confd-source \
	&& wget https://github.com/kelseyhightower/confd/archive/v0.14.0.zip \
	&& unzip v0.14.0.zip \
	&& mkdir -p /go/src/github.com/kelseyhightower \
	&& mv /confd-source/confd-0.14.0 /go/src/github.com/kelseyhightower/confd


# download metad-v1.3.zip
RUN mkdir -p /metad-source && cd /metad-source \
	&& wget https://github.com/yunify/metad/archive/v1.3.zip \
	&& unzip v1.3.zip \
	&& mkdir -p /go/src/github.com/yunify \
	&& mv /metad-source/metad-1.3 /go/src/github.com/yunify/metad

# build confd
RUN go install github.com/kelseyhightower/confd

# build metad
RUN go install github.com/yunify/metad

FROM alpine:3.6

COPY --from=builder /etcd-download/etcd-v3.2.12-linux-amd64/etcd    /usr/local/bin/etcd
COPY --from=builder /etcd-download/etcd-v3.2.12-linux-amd64/etcdctl /usr/local/bin/etcdctl
COPY --from=builder /go/bin/confd                                   /usr/local/bin/confd
COPY --from=builder /go/bin/metad                                   /usr/local/bin/metad
COPY --from=builder /go/bin/myapp                                   /usr/local/bin/myapp

EXPOSE 2379 2380

ENTRYPOINT []

CMD [ "/usr/local/bin/etcd", \
    "--data-dir=/etcd-data", \
    "--name=node1", \
    \
    "--initial-advertise-peer-urls=http://0.0.0.0:2380", \
    "--listen-peer-urls=http://0.0.0.0:2380", \
    \
    "-advertise-client-urls", "http://0.0.0.0:2379", \
    "-listen-client-urls", "http://0.0.0.0:2379", \
    \
    "--initial-cluster", "node1=http://0.0.0.0:2380" \
    ]
