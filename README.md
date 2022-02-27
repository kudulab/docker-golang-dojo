# docker-golang-dojo

A [Dojo](https://github.com/kudulab/dojo) Docker image to develop Golang projects. Based on an official Golang image.


## Usage
1. [Install Dojo](https://github.com/kudulab/dojo#installation)
2. Provide a Dojofile
```toml
DOJO_DOCKER_IMAGE="kudulab/golang-dojo:2.0.0"
```

  For experimentation purposes, you may want to create this file in our test project directory: `test/integration/test_dojo_work/executable-no-dependencies`

3. Run `dojo` while being in the same directory as the Dojofile. It will:
  * docker pull a Docker image
  * start a Docker container
  * log you into the Docker container

4. Example commands to run
```
/dojo/work$ go version
/dojo/work$ go build -o bin/main
/dojo/work$ ./bin/main
Hello, world.
```

## GOPATH, workspaces and Dojo work directory

### Dojo convention

By convention, Dojo docker containers mount the current directory from host to a docker container under `/dojo/work`. This convention is followed here. Therefore, if your project is put under `/home/me/myproject`, then you should:
* create a file `/home/me/myproject/Dojofile`
* change your current directory to `/home/me/myproject`
* invoke `dojo`

The GOPATH variable is set to `/home/dojo/go` in the Docker container. Therefore, by default, after running `go install`, the binaries will be put under `/home/dojo/go/bin`. You may want to mount this directory from your Docker host or you may want to run `go build -o bin/main` instead. The latter option allows to choose the binaries directory.

No symlinks are used.

### Golang conventions

Golang has particular workspace conventions:
  * https://golang.org/doc/code.html#Workspaces
  * https://go.dev/doc/gopath_code
  * https://github.com/golang/go/wiki/GOPATH
  * https://github.com/golang/go/wiki/GithubCodeLayout

To find the solution that fits you best, you may want to set `GOPATH`, `GOBIN`, `GOMODCACHE`, `PATH` to some custom values. Example commands to get you started:
```
export GOPATH=$HOME/go
go env -w GOPATH=$GOPATH
export GOBIN=${PWD}/bin
go env -w GOBIN=${GOBIN}
export PATH=$PATH:$GOPATH
export PATH=$PATH:$GOBIN
export GOMODCACHE=$PWD/pkg/mod
go env -w GOMODCACHE=$GOMODCACHE
```

You may also want to experiment with:
* [Dojo inner working directory](https://github.com/kudulab/dojo#inner-working-directory)
* [Dojo outer working directory](https://github.com/kudulab/dojo#outer-working-directory)


## Contributing

Instructions how to update this project.

1. Create a new feature branch from the main branch: `master`
2. Work on your changes in that feature branch. If you want, describe you changes in CHANGELOG.md
3. Build your image locally to check that it succeeds: `./tasks build_local`
4. Test your image: `./tasks itest`
5. You may want to play with the Docker container:
```
./tasks example
/dojo/work$ go build -o bin/main
/dojo/work$ ./bin/main
Hello, world.
```
6. If you are happy with the results, create a PR from your feature branch to the main branch

After this, someone will read your PR, merge it and ensure version bump (using `./tasks set_version`). CI pipeline will run to automatically build and test docker image, release the project and publish the docker image.


## License

Copyright 2019-2022 Ava Czechowska, Tom Setkowski

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
