FROM docker-registry.ai-traders.com/golang-ide:temp

COPY apt_01proxy /etc/apt/apt.conf.d/01_proxy

# * ssh-client - to run git clone over ssh
RUN apt-get update &&\
  DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
  ssh-client build-essential bash-completion

# ensure variables are set
COPY profile /home/ide/.profile
COPY bashrc /home/ide/.bashrc
RUN chown ide:ide -R /home/ide

# install glide
RUN wget -O /tmp/glide.tar.gz https://github.com/Masterminds/glide/releases/download/v0.12.3/glide-v0.12.3-linux-amd64.tar.gz &&\
  tar -xf /tmp/glide.tar.gz && mv linux-amd64/glide /usr/bin/glide &&\
  chmod 755 /usr/bin/glide && rm -rf linux-amd64

# original file: https://github.com/kura/go-bash-completion/blob/master/etc/bash_completion.d/go
# do not use: https://github.com/skelterjohn/go-pkg-complete/blob/master/go-pkg-complete.bash.inc
# because it hides the bash-completion for files and directories.
COPY bash-completion-go /etc/bash_completion.d/go
