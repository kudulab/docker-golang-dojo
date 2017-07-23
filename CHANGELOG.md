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
