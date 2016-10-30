FROM debian:jessie
MAINTAINER Rene Windegger <rene@windegger.wtf>

# Install dependencies
RUN apt-get update \
 && apt-get install -y -q --no-install-recommends \
    autoconf \
    automake \
    build-essential \
    ca-certificates \
    expect \
    libgnutls28-dev \
    libident-dev \
    libpam-dev \
    libwrap0-dev \
    libz-dev \
    telnet \
    git \
    wget \
 && apt-get clean \
 && rm -r /var/lib/apt/lists/*

# Install Forego
RUN wget -P /usr/local/bin https://github.com/jwilder/forego/releases/download/v0.16.1/forego \
 && chmod u+x /usr/local/bin/forego
 
# Setup Environment Variables
ENV DOCKER_GEN_VERSION=0.7.3

# Install Dockergen
RUN wget https://github.com/jwilder/docker-gen/releases/download/$DOCKER_GEN_VERSION/docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz \
 && tar -C /usr/local/bin -xvzf docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz \
 && rm docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz

RUN mkdir ~/src -p \
 && cd ~/src \
 && git clone git://ngircd.barton.de/ngircd.git \
 && cd ngircd \
 && ./autogen.sh \
 && ./configure --prefix=/opt/ngircd --with-ident --with-tcp-wrappers --with-gnutls --enable-ipv6 \
 && make \
 && make install

# Copy base Scripts
COPY scripts /opt/scripts/
WORKDIR /opt/scripts/

EXPOSE 6667 6668 6669
VOLUME /opt/ngircd/etc/conf.d

ENV DOCKER_HOST=unix:///tmp/docker.sock

ENTRYPOINT ["/opt/scripts/docker-entrypoint.sh"]
CMD ["forego", "start", "-r"]
