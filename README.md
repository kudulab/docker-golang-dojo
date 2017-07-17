# docker-golang-ide

An IDE docker image to build golang. Based on official golang image.

## Specification

This image has installed:
 * golang
 * glide (~bundler for golang)

## Usage
1. Install [IDE](https://github.com/ai-traders/ide)
2. Provide an Idefile:
    ```
    IDE_DOCKER_IMAGE="docker-registry.ai-traders.com/golang-ide:0.3.0"
    IDE_WORK_INNER="/ide/work/src/myproject"
    ```

By default, current directory in docker container is whatever you set to IDE_WORK_INNER,
 which defaults to `/ide/work`.

Example commands:
```
glide install
go test
```

### Workspace

Golang has a particular workspace convention:
  * https://golang.org/doc/code.html#Workspaces
  * https://github.com/golang/go/wiki/GOPATH
  * https://github.com/golang/go/wiki/GithubCodeLayout

In this IDE docker image we always set `GOPATH=/ide/work` and provide proper directory layout.

You have 2 options here:
  1. keep 1 Idefile for many golang projects. Your workspace will look like that:
  ```
  .git/
  bin/
  pkg/
  src/
    01-example/
      package1/
        some_go_file.go
        some_go_file_test.go
      package2/
        another_go_file.go
    02-abc/
      abc.go
  Idefile
  ```
  Inside golang-ide container, your workspace is mounted into `/ide/work`.
  No need to set anything unusual in Idefile.
  2. keep 1 Idefile for 1 golang project. Your workspace will look like that:
  ```
  .git/
  package1/
    some_go_file.go
    some_go_file_test.go
  package2/
    another_go_file.go
  Idefile
  ```
  You have to:
   * set IDE_WORK_INNER in Idefile to something under `/ide/work/src`,
    e.g. `/ide/work/src/github.com/user/hello`.
   * use IDE >= 0.9.0. Since then, the ide_work variable inside a container is
    the directory mounted as docker volume.

----

Whichever option you choose, the directories `/ide/work/bin/` and `/ide/work/pkg/` will be provided. In result, the compiled files `*.a` are available on docker host too.


### Configuration

1. `~/.ssh/config` -- will be generated on docker container start
2. `~/.ssh/id_rsa` -- it must exist locally, because it is a secret
 (but the whole `~/.ssh` will be copied)
2. `~/.gitconfig` -- if exists locally, will be copied
3. `~/.profile` -- will be generated on docker container start, in
   order to ensure current directory is `${ide_work}`.

## Development
### Dependencies
* Bash
* Docker daemon
* Bats
* Ide

Need to install bats with:

```sh
git clone --depth 1 https://github.com/sstephenson/bats.git /opt/bats
git clone --depth 1 https://github.com/ztombol/bats-support.git /opt/bats-support
git clone --depth 1 https://github.com/ztombol/bats-assert.git /opt/bats-assert
/opt/bats/install.sh /usr/local
```

### Tests
There are 2 Dockerfiles:
  * Dockerfile_ide_configs -- to test IDE configuration files and fail fast
  * Dockerfile -- to build the main ide image, based on image built from
   Dockerfile_ide_configs

### Lifecycle
1. In a feature branch:
   * you make changes
   * and run tests:
       * `./tasks build_cfg`
       * `./tasks test_cfg`
       * `./tasks build`
       * `./tasks itest`
1. You decide that your changes are ready and you:
   * merge into master branch
   * run locally:
     * `./tasks set_version` to set version in CHANGELOG and chart version files to
     the version from OVersion backend
     * e.g. `./tasks set_version 1.2.3` to set version in CHANGELOG and chart version
      files and in OVersion backend to 1.2.3
   * push to master onto private git server
1. CI server (GoCD) tests and releases.
