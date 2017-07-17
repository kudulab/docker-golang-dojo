#!/bin/bash

if [[ -z "${ide_work}" ]]; then
  echo "Fail! ide_work is not set. IDE >= 0.9.0 is needed"
  exit 1
fi
