### 0.3.5 (2018-Jun-30)

* golang 1.10.3

### 0.3.4 (2018-Mar-29)

* install https://github.com/golang/dep #12700

### 0.3.3 (2018-Jan-30)

* newer base image `golang:1.9.3-stretch`
* dev: 1 Dockerfile instead of 2
* dev: remove a test which builds golang go-agent, it is obsolete

### 0.3.2 (2017-Jul-23)
### 0.3.1 (2017-Jul-23)

* `chown ide:ide /ide/work/src`, so that `go get -u` works

### 0.3.0 (2017-Jul-17)

* support 1 Idefile for 1 golang project, user must set IDE_WORK_INNER
 in Idefile

### 0.2.1 (2017-Jul-08)

* better bash-completion
* make `build_cfg` task set version from code, not from OVersion backend

### 0.2.0 (2017-Jul-08)

* facilities for interactive shell:
  * fix bash prompt to be colorful
  * add bash-completion
* base image: golang:1.7 -> golang:1.8.3

### 0.1.0 (4 May 2017)

Initial release
