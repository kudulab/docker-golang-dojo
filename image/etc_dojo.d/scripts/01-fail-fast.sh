#!/bin/bash

if [[ -z "${dojo_work}" ]]; then
  echo "Fail! dojo_work is not set."
  exit 1
fi
