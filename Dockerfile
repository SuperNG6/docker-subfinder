FROM lsiobase/ubuntu:bionic

# set label
LABEL maintainer="NG6"
ENV TZ=Asia/Shanghai PUID=1026 PGID=100 

# install subfinder
RUN apt -y update && apt -y install python3 python3-pip unrar cron \
&&  pip3 install --upgrade pip \
&&  pip install subfinder \
&&  echo "**** cleanup ****" \
&&  apt-get clean \
&&  rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*

# copy local files
COPY root/ /

# volumes
VOLUME /config	/media
