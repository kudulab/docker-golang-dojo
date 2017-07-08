# docker-golang-ide

An IDE docker image to build golang. Based on official golang image.

## Specification

This image has installed:
 * golang

## Usage
1. Install [IDE](https://github.com/ai-traders/ide)
2. Provide an Idefile:
```
IDE_DOCKER_IMAGE="docker-registry.ai-traders.com/golang-ide:0.1.1"
```

By default, current directory in docker container is `/ide/work`.

### Workspace

Golang has [workspace convention](https://golang.org/doc/code.html#Workspaces) which is not friendly towards IDE concepts.
It prefers to have one workspace for all your projects, while IDE says each project should have its own environment.

The **Go-way** of working is by having Idefile at the root of many projects, that implies unversioned.

*TODO: Is it possible to have Idefile in project at all?*
 * `/ide/go` is the `GOPATH`, that implies it will hold all projects, including dependencies of the current project. It has 3 subdirectories:
    - `bin` contains executable commands
    - `pkg` contains package objects
    - `src` contains Go source files
 * we want `/ide/work` to be the root of current project.

### Configuration
Those files are used inside the ide docker image:

1. `~/.ssh/config` -- will be generated on docker container start
2. `~/.ssh/id_rsa` -- it must exist locally, because it is a secret
 (but the whole `~/.ssh` will be copied)
2. `~/.gitconfig` -- if exists locally, will be copied
3. `~/.profile` -- will be generated on docker container start, in
   order to ensure current directory is `/ide/work`.

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
