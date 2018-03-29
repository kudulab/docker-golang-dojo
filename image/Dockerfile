FROM golang:1.9.3-stretch

COPY apt_01proxy /etc/apt/apt.conf.d/01_proxy
ARG AIT_USE_APT_CACHE
RUN /bin/bash -c "if [[ ${AIT_USE_APT_CACHE} == false ]]; then rm /etc/apt/apt.conf.d/01_proxy; fi"

################################################################################
# For ide
################################################################################
# * entrypoint requires sudo
# * git is needed to install ide image configs
# * ca-certificated needed when running git clone to avoid this error:
# fatal: unable to access 'https://github.com/ai-traders/ide.git/': Problem with the SSL CA cert (path? access rights?)
RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  sudo git ca-certificates wget && \
  git clone --depth 1 -b 0.10.2 https://github.com/ai-traders/ide.git /tmp/ide_git && \
  /tmp/ide_git/ide_image_scripts/src/install.sh && \
  rm -r /tmp/ide_git && \
  echo 'ide ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

################################################################################
# Above ide
################################################################################

# Install common usage apt packages.
# * ssh-client - to run git clone over ssh
# * locale-gen en_US.UTF-8 - so that perl does not complain like: "perl: warning: Setting locale failed."
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF &&\
  apt-get update &&\
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  apt-utils locales git unzip wget nano ssh-client build-essential bash-completion &&\
  locale-gen en_US.UTF-8 && localedef -i en_US -f UTF-8 en_US.UTF-8 && update-locale &&\
  apt-get -y autoremove && apt-get -y autoclean && apt-get -y clean &&\
  rm -rf /tmp/* /var/tmp/* && rm -rf /var/lib/apt/lists/*

# install glide
RUN wget -O /tmp/glide.tar.gz https://github.com/Masterminds/glide/releases/download/v0.13.1/glide-v0.13.1-linux-amd64.tar.gz &&\
  tar -xf /tmp/glide.tar.gz && mv linux-amd64/glide /usr/bin/glide &&\
  chmod 755 /usr/bin/glide && rm -rf linux-amd64

# install dep
RUN cd /tmp &&\
  wget https://github.com/golang/dep/releases/download/v0.4.1/dep-linux-amd64 &&\
  mv dep-linux-amd64 /usr/bin/dep &&\
  chmod +x /usr/bin/dep

# original file: https://github.com/kura/go-bash-completion/blob/master/etc/bash_completion.d/go
# do not use: https://github.com/skelterjohn/go-pkg-complete/blob/master/go-pkg-complete.bash.inc
# because it hides the bash-completion for files and directories.
COPY bash-completion-go /etc/bash_completion.d/go

# ensure variables are set
COPY profile /home/ide/.profile
COPY bashrc /home/ide/.bashrc
RUN chown ide:ide -R /home/ide

COPY etc_ide.d/scripts/* /etc/ide.d/scripts/
COPY sudoers /tmp/sudoers.new
RUN visudo -c -f /tmp/sudoers.new && cp /tmp/sudoers.new /etc/sudoers

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
CMD ["/bin/bash"]

ARG this_image_tag_arg
ARG this_image_name_arg
ENV this_image_tag=${this_image_tag_arg} this_image_name=${this_image_name_arg}
