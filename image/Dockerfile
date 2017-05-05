FROM docker-registry.ai-traders.com/golang-ide:temp

COPY apt_01proxy /etc/apt/apt.conf.d/01_proxy

# * software-properties-common - to make add-apt-repository work
# * ssh-client - to run git clone over ssh
RUN apt-get update &&\
  DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
  ssh-client build-essential
# ensure varables are set
COPY profile /home/ide/.profile
COPY environment /etc/environment

ENV GOPATH /ide/work
ENV PATH /ide/work/bin:/usr/local/go/bin:$PATH
WORKDIR /ide/work
