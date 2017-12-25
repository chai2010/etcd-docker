# Copyright 2017 The OpenPitrix Authors. All rights reserved.
# Use of this source code is governed by a Apache license
# that can be found in the LICENSE file.

TARG:=chai2010/etcd

default:
	docker build -t $(TARG) -f ./Dockerfile .

run:
	docker run --rm -it $(TARG)

clean:

