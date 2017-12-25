# Copyright 2017 The OpenPitrix Authors. All rights reserved.
# Use of this source code is governed by a Apache license
# that can be found in the LICENSE file.

# https://coreos.com/etcd/docs/latest/op-guide/container.html#docker
# https://coreos.com/etcd/docs/latest/v2/api.html

TARG:=chai2010/etcd

DOCKER_FLAGS:=-p 2379:2379
DOCKER_FLAGS+=-p 2380:2380
DOCKER_FLAGS+=--volume=`pwd`/etcd-data:/etcd-data
DOCKER_FLAGS+=--name etcd

default:
	docker run --rm -it $(DOCKER_FLAGS) $(TARG)

debug:
	docker run --rm -it $(DOCKER_FLAGS) -d $(TARG) etcd \
		--name=node1 \
		--data-dir=/etcd-data \
		--advertise-client-urls=http://0.0.0.0:2379 \
		--listen-client-urls=http://0.0.0.0:2379

start:
	docker run --rm -it $(DOCKER_FLAGS) -d $(TARG)

stop:
	docker stop etcd

build:
	docker build -t $(TARG) -f ./Dockerfile .

pull:
	docker pull $(TARG)

test:
	curl localhost:2379/version
	curl localhost:2379/v2/keys
	-docker exec etcd etcdctl mkdir /dir
	curl localhost:2379/v2/keys
	-curl http://127.0.0.1:2379/v2/keys/message -XPUT -d value="Hello world"
	curl http://127.0.0.1:2379/v2/keys/message
	curl http://127.0.0.1:2379/v2/keys/message -XDELETE
	curl http://127.0.0.1:2379/v2/keys/foo -XPUT -d value=bar -d ttl=5
	curl http://127.0.0.1:2379/v2/keys/foo


clean:
	-docker stop $(TARG)
	-rm -rf ./etcd-data
