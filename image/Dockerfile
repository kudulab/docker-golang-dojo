FROM docker-registry.ai-traders.com/golang-ide:temp

COPY apt_01proxy /etc/apt/apt.conf.d/01_proxy

# * ssh-client - to run git clone over ssh
RUN apt-get update &&\
  DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
  ssh-client build-essential

# ensure variables are set
COPY profile /home/ide/.profile
COPY bashrc /home/ide/.bashrc
RUN chown ide:ide -R /home/ide
