FROM debian:buster
MAINTAINER Carles Amigó, fr3nd@fr3nd.net

ENV MOTION_VERSION 4.3.2
ENV MOTIONEYE_VERSION 795616d

RUN apt-get update && DEBIAN_FRONTEND="noninteractive" apt-get install -y \
      curl \
      git \
      ffmpeg \
      libcurl4-openssl-dev \
      libjpeg-dev \
      libmariadb3 \
      libmicrohttpd12 \
      libpq5 \
      libssl-dev \
      libz-dev \
      mariadb-common \
      mysql-common \
      python \
      python-dev \
      python-pip \
      python-setuptools \
      v4l-utils \
      && rm -rf /usr/share/doc/* && \
      rm -rf /usr/share/info/* && \
      rm -rf /tmp/* && \
      rm -rf /var/tmp/*

RUN curl -o /tmp/motion.deb -L https://github.com/Motion-Project/motion/releases/download/release-${MOTION_VERSION}/buster_motion_${MOTION_VERSION}-1_amd64.deb && \
      dpkg -i /tmp/motion.deb && \
      rm -f /tmp/motion.deb

RUN git clone https://github.com/ccrisan/motioneye.git /var/src/motioneye && \
      git --git-dir /var/src/motioneye/.git checkout $MOTIONEYE_VERSION && \
      pip install /var/src/motioneye && \
      mkdir -p /etc/motioneye && \
      mkdir -p /var/lib/motioneye && \
      cp /usr/local/share/motioneye/extra/motioneye.conf.sample /etc/motioneye/motioneye.conf && \
      rm -rf /var/src/motioneye

VOLUME /etc/motioneye
VOLUME /var/lib/motioneye

CMD /usr/local/bin/meyectl startserver -c /etc/motioneye/motioneye.conf
