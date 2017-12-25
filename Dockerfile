# Copyright 2017 The OpenPitrix Authors. All rights reserved.
# Use of this source code is governed by a Apache license
# that can be found in the LICENSE file.

FROM alpine:3.6 as builder

RUN apk add --no-cache curl openssl

RUN curl -L https://github.com/coreos/etcd/releases/download/v3.2.12/etcd-v3.2.12-linux-amd64.tar.gz | tar zx

FROM alpine:3.6

COPY --from=builder /etcd-v3.2.12-linux-amd64/etcd    /usr/local/bin/etcd
COPY --from=builder /etcd-v3.2.12-linux-amd64/etcdctl /usr/local/bin/etcdctl

CMD ["/usr/local/bin/etcd"]
