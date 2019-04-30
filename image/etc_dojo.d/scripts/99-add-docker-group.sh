#!/bin/bash

socket_file="${DOCKER_SOCKET_FILE:-/run/docker.sock}"

if test -S "${socket_file}"; then
    echo "${socket_file} exists"

  # Add group: docker if does not exist
  if ! cat /etc/group | grep docker; then
  	echo "creating group: docker"
  	gid=$(stat -c "%g" "${socket_file}")
  	groupadd --gid ${gid} docker
  	usermod -a -G docker dojo
  fi
else
    echo "${socket_file} does not exist"
fi
