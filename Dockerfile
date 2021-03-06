FROM anapsix/alpine-java:8_server-jre
MAINTAINER Alan Jenkins <alan.james.jenkins@gmail.com>

ENV MCMEM=4000
ENV MCUID=995
ENV MCGID=994

RUN apk --no-cache add gcc python git musl-dev ca-certificates wget && \
    update-ca-certificates && \
    cd /tmp/ && \
    git clone https://github.com/Tiiffi/mcrcon.git && \
    cd /tmp/mcrcon/ && \
    gcc -std=gnu11 -pedantic -Wall -Wextra -O2 -s -o mcrcon mcrcon.c && \
    cp mcrcon /usr/bin/mcrcon && \
    rm -Rf /tmp/mcrcon

ADD get_pack.py /usr/bin/get_pack
RUN mkdir -p /srv/minecraft && \
    cd /srv/minecraft/ && \
    /usr/bin/get_pack sprout && \
    rm /srv/minecraft/minecraft.zip /usr/bin/get_pack && \
    mkdir /srv/minecraft/world && \
    echo 'eula=true' > /srv/minecraft/eula.txt && \
    cd /srv/minecraft/ && \
    apk del --purge git gcc musl-dev ca-certificates wget python

RUN rm /srv/minecraft/mods/animania-1.10.2-1.3.3.jar

ADD server.properties /srv/minecraft/server.properties
ADD start_mc.sh /usr/bin/start_mc
RUN chmod +x /usr/bin/start_mc

VOLUME /srv/minecraft/world
VOLUME /srv/minecraft/config.override
VOLUME /srv/minecraft/mods.override
VOLUME /srv/minecraft/crash-reports
VOLUME /srv/minecraft/backups

CMD cd /srv/minecraft && \
    /usr/bin/start_mc
