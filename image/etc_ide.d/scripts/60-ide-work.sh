#!/bin/bash -e

# Golang has a particular workspace convention:
#   * https://golang.org/doc/code.html#Workspaces
#   * https://github.com/golang/go/wiki/GOPATH
#   * https://github.com/golang/go/wiki/GithubCodeLayout
#
# In this IDE docker image we always set `GOPATH=/ide/work` and provide proper directory layout.
#
# You have 2 options here:
#   1. keep 1 Idefile for many golang projects. Your workspace will look like that:
#   ```
#   .git/
#   bin/
#   pkg/
#   src/
#     01-example/
#       package1/
#         some_go_file.go
#         some_go_file_test.go
#       package2/
#         another_go_file.go
#     02-abc/
#       abc.go
#   Idefile
#   ```
#   Inside golang-ide container, your workspace is mounted into `/ide/work`.
#   No need to set anything unusual in Idefile.
#   2. keep 1 Idefile for 1 golang project. Your workspace will look like that:
#   ```
#   .git/
#   package1/
#     some_go_file.go
#     some_go_file_test.go
#   package2/
#     another_go_file.go
#   Idefile
#   ```
#   You have to:
#    * set IDE_WORK_INNER in Idefile to something under `/ide/work/src`,
#     e.g. `/ide/work/src/github.com/user/hello`.
#    * use IDE >= 0.9.0. Since then, the ide_work variable inside a container is
#     the directory mounted as docker volume.
#
# ----
#
# Whichever option you choose, the directories `/ide/work/bin/` and `/ide/work/pkg/` will be provided. In result, the compiled files `*.a` are available on docker host too.

# Create /ide/work/png, either a directory or a symlink to ./png
(set -x; mkdir -p "${ide_work}/pkg"; )
if [[ "${ide_work}/pkg" != "/ide/work/pkg" ]]; then
  (set -x; ln -sf "${ide_work}/pkg" /ide/work/pkg; )
fi

# Create /ide/work/bin, either a directory or a symlink to ./bin
(set -x; mkdir -p "${ide_work}/bin"; )
if [[ "${ide_work}/bin" != "/ide/work/bin" ]]; then
  (set -x; ln -sf "${ide_work}/bin" /ide/work/bin; )
fi

(set -x; chown -R ${owner_username}:${owner_groupname} "${ide_work}/pkg"; )
(set -x; chown -R ${owner_username}:${owner_groupname} "${ide_work}/bin"; )
(set -x; mkdir -p "${ide_work}/src" && chown ${owner_username}:${owner_groupname} "${ide_work}/src"; )
