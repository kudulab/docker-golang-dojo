FROM golang:1.21.1-bookworm

################################################################################
# For Dojo
################################################################################
# * sudo is needed in entrypoint
# * git is needed to install dojo image configs
# * ca-certificated is needed to run git clone from https site (e.g. https://github.com)
RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  sudo git ca-certificates wget && \
  git clone --depth 1 -b 0.13.0 https://github.com/kudulab/dojo.git /tmp/dojo_git &&\
  /tmp/dojo_git/image_scripts/src/install.sh && \
  rm -r /tmp/dojo_git && \
  echo 'dojo ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

################################################################################
# Above Dojo
################################################################################

# Install common usage apt packages.
# * ssh-client - to run git clone over ssh
# * locale-gen en_US.UTF-8 - so that perl does not complain like: "perl: warning: Setting locale failed."
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF &&\
  apt-get update &&\
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  apt-utils locales git unzip wget nano ssh-client build-essential bash-completion libseccomp-dev &&\
  locale-gen en_US.UTF-8 && localedef -i en_US -f UTF-8 en_US.UTF-8 && update-locale &&\
  apt-get -y autoremove && apt-get -y autoclean && apt-get -y clean &&\
  rm -rf /tmp/* /var/tmp/* && rm -rf /var/lib/apt/lists/*

# for dojo user to be able to rebuild go native libraries
RUN chown dojo:dojo -R /usr/local/go/

# original file: https://github.com/kura/go-bash-completion/blob/master/etc/bash_completion.d/go
# do not use: https://github.com/skelterjohn/go-pkg-complete/blob/master/go-pkg-complete.bash.inc
# because it hides the bash-completion for files and directories.
COPY bash-completion-go /etc/bash_completion.d/go

# ensure variables are set
COPY profile /home/dojo/.profile
COPY bashrc /home/dojo/.bashrc
RUN chown dojo:dojo -R /home/dojo

COPY etc_dojo.d/scripts/* /etc/dojo.d/scripts/

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
CMD ["/bin/bash"]
