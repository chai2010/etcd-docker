# etcd-v3 docker image

[![Docker Build Status](https://img.shields.io/docker/build/chai2010/etcd.svg)](https://hub.docker.com/r/chai2010/etcd/)
[![License](http://img.shields.io/badge/license-apache%20v2-blue.svg)](https://github.com/openpitrix/openpitrix/blob/master/LICENSE)

## Quick Guide

```
$ docker run --rm -it -p 2379:2379 -p 2380:2380 --name etcd chai2010/etcd

$ curl curl 127.0.0.1:2379/version
$ curl curl 127.0.0.1:2379/v2/keys

$ curl http://127.0.0.1:2379/v2/keys/message -XPUT -d value="Hello world"

$ curl curl 127.0.0.1:2379/v2/keys
$ curl http://127.0.0.1:2379/v2/keys/message
```

## Run Test

```
make debug
make test
make clean
```

## License

The Apache License.
