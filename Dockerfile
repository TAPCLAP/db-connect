FROM docker.io/ubuntu:24.04
LABEL org.opencontainers.image.source https://github.com/orangeappsru/db-connect

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        vim \
        less \
        bash-completion \
        iputils-ping \
        dnsutils \
        nano \
        tmux \
        screen \
        curl \
        ca-certificates \
        redis-tools \
        nodejs \
        gnupg \
        libcurl4 \
        openssl \
        liblzma5 \
        netcat-openbsd \
        gnupg2 \
        lsb-release \
    && curl -o mongodb-mongosh_2.9.2_amd64.deb -L 'https://repo.mongodb.org/apt/ubuntu/dists/jammy/mongodb-org/7.0/multiverse/binary-amd64/mongodb-mongosh_2.9.2_amd64.deb' \
    && dpkg -i mongodb-mongosh_2.9.2_amd64.deb \
    && rm -fv mongodb-mongosh_2.9.2_amd64.deb \
    && curl -O https://repo.percona.com/apt/percona-release_latest.generic_all.deb \
    && apt-get install --no-install-recommends -y ./percona-release_latest.generic_all.deb \
    && apt-get update \
    && percona-release setup ps80 \
    && apt-get install --no-install-recommends -y percona-server-client \
    && apt-get autoclean \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -fv /bin/sh \
    && ln -s -v /bin/bash /bin/sh \
    && mkdir /user

COPY ./.bash_profile /user/
COPY ./.tmux.conf /user/
RUN chmod 755 /user; chmod 755 /user/.bash_profile; chmod 644 /user/.tmux.conf
COPY ./entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
