# docker-golang-dojo

A [Dojo](https://github.com/ai-traders/dojo) docker image to develop golang projects. Based on official golang image.

## Specification

This image has installed:
 * golang `1.11.0`
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
4. Run `dojo` to start container with golang environment.

By default, current directory in docker container is [DOJO_WORK_INNER](https://github.com/ai-traders/dojo#inner-working-directory),
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
Those files are used inside the docker image:

1. `~/.ssh/` -- is copied from host to dojo's home `~/.ssh`
1. `~/.ssh/config` -- will be generated on docker container start. SSH client is configured to ignore known ssh hosts.
2. `~/.gitconfig` -- if exists locally, will be copied
3. `~/.profile` -- will be generated on docker container start, in
   order to ensure current directory is [DOJO_WORK_INNER](https://github.com/ai-traders/dojo#inner-working-directory).

## License

Copyright 2019 Ewa Czechowska, Tomasz Sętkowski

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
