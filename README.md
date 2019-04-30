# docker-golang-ide

A [Dojo](https://github.com/ai-traders/dojo) docker image to develop golang projects. Based on official golang image.

## Specification

This image has installed:
 * golang
 * glide (dependency manager for golang)

## Usage
1. [Install docker](https://docs.docker.com/install/), if you haven't already.
2. [Install Dojo](https://github.com/ai-traders/dojo#installation), it is a self-contained binary, so just place it somewhere on the `PATH`.
On **Linux**:
```bash
DOJO_VERSION=0.4.2
wget -O dojo https://github.com/ai-traders/dojo/releases/download/${DOJO_VERSION}/dojo_linux_amd64
sudo mv dojo /usr/local/bin
sudo chmod +x /usr/local/bin/dojo
```
3. Provide a Dojofile:
```toml
DOJO_DOCKER_IMAGE="docker-ai-traders.com/golang-ide:1.0.0"
DOJO_WORK_INNER="/dojo/work/src/myproject"
```

By default, current directory in docker container is whatever you set to DOJO_WORK_INNER,
 which defaults to `/dojo/work`.

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

This is not very compliant with [Dojo](https://github.com/ai-traders/dojo) conventions, because it expects to have single environment for multiple projects, while dojo is about having a specific environment for each project.

This image works around it anyway. We always set `GOPATH=/dojo/work` and provide proper directory layout.

You have 2 options here:
  1. keep 1 Dojofile for many golang projects. Your workspace will look like that:
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
  Dojofile
  ```
  Inside `golang-dojo` container, your workspace is mounted into `/dojo/work`.
  No need to set anything unusual in Dojofile.
  2. keep 1 Dojofile for 1 golang project. Your workspace will look like that:
  ```
  .git/
  package1/
    some_go_file.go
    some_go_file_test.go
  package2/
    another_go_file.go
  Dojofile
  ```
  You have to:
   * set `DOJO_WORK_INNER` in Dojofile to something under `/dojo/work/src`,
    e.g. `/dojo/work/src/github.com/user/hello`.

----

Whichever option you choose, the directories `/dojo/work/bin/` and `/dojo/work/pkg/` will be provided. In result, the compiled files `*.a` are available on docker host too.

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
* Dojo

Need to install bats with:

```sh
git clone --depth 1 https://github.com/sstephenson/bats.git /opt/bats
git clone --depth 1 https://github.com/ztombol/bats-support.git /opt/bats-support
git clone --depth 1 https://github.com/ztombol/bats-assert.git /opt/bats-assert
/opt/bats/install.sh /usr/local
```

### Lifecycle
1. In a feature branch:
   * you make changes
   * and run tests:
       * `./tasks build`
       * `./tasks itest`
1. You decide that your changes are ready and you:
   * merge into master branch
   * run locally:
     * e.g. `./tasks set_version 1.2.3` to set version in CHANGELOG to 1.2.3
   * push to master onto private git server
1. CI server (GoCD) tests and releases.
