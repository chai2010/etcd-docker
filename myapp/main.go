// Copyright 2017 <chaishushan{AT}gmail.com>. All rights reserved.
// Use of this source code is governed by a BSD license
// that can be found in the LICENSE file.

package main

import (
	"flag"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
)

var (
	flagPort   = flag.Int("port", 8080, "listen on port")
	flagConfig = flag.String("conf", "/etc/myapp.json", "set config path")
)

func main() {
	flag.Parse()

	conf := loadConfig(*flagConfig)
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintln(w, conf)
	})

	addr := fmt.Sprintf(":%d", *flagPort)
	fmt.Println("[myapp] start on", addr)

	log.Fatal(http.ListenAndServe(addr, nil))
}

func loadConfig(path string) string {
	d, err := ioutil.ReadFile(path)
	if err != nil {
		return fmt.Sprintf("<%q not found>", path)
	}
	return string(d)
}
