# etcd-v3 docker image

[![Docker Build Status](https://img.shields.io/docker/build/chai2010/etcd.svg)](https://hub.docker.com/r/chai2010/etcd/)
[![License](http://img.shields.io/badge/license-apache%20v2-blue.svg)](https://github.com/openpitrix/openpitrix/blob/master/LICENSE)

## Quick Guide (Docker)

```shell
$ docker run --rm -it -p 2379:2379 -p 2380:2380 --name etcd chai2010/etcd

$ curl 127.0.0.1:2379/version
$ curl 127.0.0.1:2379/v2/keys

$ curl http://127.0.0.1:2379/v2/keys/message -XPUT -d value="Hello world"

$ curl 127.0.0.1:2379/v2/keys
$ curl http://127.0.0.1:2379/v2/keys/message
```

## Quick Guide (Cluster/Docker Compose)

```shell
# start 3 node, port on :2379/:3379/:4379
$ docker-compose up -d

$ curl 127.0.0.1:2379/version
$ curl 127.0.0.1:2379/v2/keys

$ curl http://127.0.0.1:2379/v2/keys/message -XPUT -d value="Hello world"

$ curl 127.0.0.1:2379/v2/keys
$ curl http://127.0.0.1:2379/v2/keys/message

# get from other etcd node
$ curl 127.0.0.1:3379/v2/keys
```

## Connect to host from docker container

- Linux: 172.17.0.1
- macOS: [docker.for.mac.localhost](https://docs.docker.com/docker-for-mac/networking/)
- Windows: [docker.for.win.localhost](https://docs.docker.com/docker-for-windows/release-notes/)
- Vagrant: 10.0.2.2

<!--
https://stackoverflow.com/questions/45461017/connect-to-host-mongodb-from-docker-container

https://stackoverflow.com/questions/33777041/why-10-0-2-2-was-not-there-with-running-ifconfig
https://www.douban.com/group/topic/15558388/
-->

## Run Test

```
make debug
make test
make clean
```

## License

The Apache License.
