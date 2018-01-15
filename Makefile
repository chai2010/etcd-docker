# Copyright 2017 <chaishushan{AT}gmail.com>. All rights reserved.
# Use of this source code is governed by a BSD license
# that can be found in the LICENSE file.

# https://coreos.com/etcd/docs/latest/op-guide/container.html#docker
# https://coreos.com/etcd/docs/latest/v2/api.html

TARG:=chai2010/etcd

DOCKER_ETCD_FLAGS:=-p 2379:2379
DOCKER_ETCD_FLAGS+=-p 2380:2380
DOCKER_ETCD_FLAGS+=--volume=`pwd`/etcd-data:/etcd-data
DOCKER_ETCD_FLAGS+=--name etcd

DOCKER_METAD_FLAGS:=
DOCKER_METAD_FLAGS+=-p 9611:9611
DOCKER_METAD_FLAGS+=-p 9080:8080
DOCKER_METAD_FLAGS+=--name metad

DOCKER_CONFD_FLAGS:=
DOCKER_CONFD_FLAGS+=-p 8080:8080
DOCKER_CONFD_FLAGS+=--volume=`pwd`/conf-data/etc:/etc
DOCKER_CONFD_FLAGS+=--name confd

default:
	docker run --rm -it $(DOCKER_ETCD_FLAGS) $(TARG)

debug:
	docker run --rm -it $(DOCKER_ETCD_FLAGS) -d $(TARG) etcd \
		--name=node1 \
		--data-dir=/etcd-data \
		--advertise-client-urls=http://0.0.0.0:2379 \
		--listen-client-urls=http://0.0.0.0:2379

sh:
	docker exec -it etcd sh

up:
	docker-compose up -d

down:
	docker-compose down

metad-macos:
	docker run --rm -it $(DOCKER_METAD_FLAGS) $(TARG) metad \
		--backend etcdv3 \
		--nodes http://docker.for.mac.localhost:2379 \
		--log_level debug \
		--listen :8080 \
		--xff

confd-linux:
	-curl http://127.0.0.1:2379/v2/keys/myapp/database/url -XPUT -d value="db.example.com"
	-curl http://127.0.0.1:2379/v2/keys/myapp/database/user -XPUT -d value="rob"

	docker run --rm -it $(DOCKER_CONFD_FLAGS) $(TARG) confd -watch -backend etcd -log-level=DEBUG -node http://172.17.0.1:2379

confd-macos:
	-curl http://127.0.0.1:2379/v2/keys/myapp/database/url -XPUT -d value="db.example.com"
	-curl http://127.0.0.1:2379/v2/keys/myapp/database/user -XPUT -d value="rob"
	
	docker run --rm -it $(DOCKER_CONFD_FLAGS) $(TARG) confd -watch -backend etcd -config-file=/etc/confd/confd-macos.toml

confd-win:
	-curl http://127.0.0.1:2379/v2/keys/myapp/database/url -XPUT -d value="db.example.com"
	-curl http://127.0.0.1:2379/v2/keys/myapp/database/user -XPUT -d value="rob"
	
	docker run --rm -it $(DOCKER_CONFD_FLAGS) $(TARG) confd -watch -backend etcd -log-level=DEBUG -node http://docker.for.win.localhost:2379

start:
	docker run --rm -it $(DOCKER_ETCD_FLAGS) -d $(TARG)

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
	-rm -rf ./etcd-node1-data
	-rm -rf ./etcd-node2-data
	-rm -rf ./etcd-node3-data
