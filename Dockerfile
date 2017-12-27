# Copyright 2017 <chaishushan{AT}gmail.com>. All rights reserved.
# Use of this source code is governed by a BSD license
# that can be found in the LICENSE file.

# https://coreos.com/etcd/docs/latest/op-guide/container.html#docker
# https://coreos.com/etcd/docs/latest/v2/api.html

FROM alpine:3.6 as builder

RUN apk add --no-cache curl openssl

RUN curl -L https://github.com/coreos/etcd/releases/download/v3.2.12/etcd-v3.2.12-linux-amd64.tar.gz | tar zx
RUN curl -L https://github.com/kelseyhightower/confd/releases/download/v0.14.0/confd-0.14.0-darwin-amd64 > /usr/local/bin/confd
RUN chmod +x /usr/local/bin/confd

FROM alpine:3.6

COPY --from=builder /etcd-v3.2.12-linux-amd64/etcd    /usr/local/bin/etcd
COPY --from=builder /etcd-v3.2.12-linux-amd64/etcdctl /usr/local/bin/etcdctl
COPY --from=builder /usr/local/bin/confd              /usr/local/bin/confd

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
