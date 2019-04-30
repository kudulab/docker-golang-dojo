#!/bin/bash -e

# Create /dojo/work/png, either a directory or a symlink to ./png
(set -x; mkdir -p "${dojo_work}/pkg"; )
if [[ "${dojo_work}/pkg" != "/dojo/work/pkg" ]]; then
  (set -x; ln -sf "${dojo_work}/pkg" /dojo/work/pkg; )
fi

# Create /dojo/work/bin, either a directory or a symlink to ./bin
(set -x; mkdir -p "${dojo_work}/bin"; )
if [[ "${dojo_work}/bin" != "/dojo/work/bin" ]]; then
  (set -x; ln -sf "${dojo_work}/bin" /dojo/work/bin; )
fi

(set -x; chown -R ${owner_username}:${owner_groupname} "${dojo_work}/pkg"; )
(set -x; chown -R ${owner_username}:${owner_groupname} "${dojo_work}/bin"; )
# notice that below we do not work on "${dojo_work}/src"
(set -x; mkdir -p "/dojo/work/src" && chown ${owner_username}:${owner_groupname} "/dojo/work/src"; )
