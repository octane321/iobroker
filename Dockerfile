FROM debian:stretch

# inspired by https://github.com/Locke/docker-iobroker

MAINTAINER Joscha Middendorf <joscha.middendorf@me.com>

RUN mkdir -p /opt/iobroker/
WORKDIR /opt/iobroker/

RUN \
    ## update and upgrade APT
    apt-get update \
    && apt-get -qqy dist-upgrade \
    \
    ## Install dependencies
    && apt-get -qqy install \
        curl \
        gnupg \
    \
    && curl -sL https://deb.nodesource.com/setup_8.x | bash - \
    \
    && apt-get -qqy install \
        build-essential \
        libavahi-compat-libdnssd-dev \
        libudev-dev \
        libpam0g-dev \
        nodejs \
    \
    ## Install IoBroker
    #&& curl -sL https://raw.githubusercontent.com/ioBroker/ioBroker/stable-installer/installer.sh | bash - \
    && npm install iobroker --unsafe-perm \
    && npm i --production --unsafe-perm \
    \
    ## Clean up APT when done
    && apt-get autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
    
COPY scripts/run.sh /root/
RUN chmod +x /root/run.sh

## extract instalation for later intitialisation
##run tar -czf "$PACKAGE" "$2"

#RUN npm install iobroker --unsafe-perm
#RUN npm i --production --unsafe-perm

VOLUME /opt/iobroker/

EXPOSE 8081 8082 8083 8084
CMD /opt/iobroker/run.sh
