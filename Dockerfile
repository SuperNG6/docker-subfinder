FROM lsiobase/ubuntu:bionic

# set label
LABEL maintainer="NG6"
ENV TZ=Asia/Shanghai AUTOEXIT=true PUID=1026 PGID=100

# install subfinder
RUN apt -y update && apt -y install python3 python3-pip unrar \
&&	pip3 install --upgrade pip \
&&  pip install subfinder \
&&	mkdir /libraries \
&&  echo "**** cleanup ****" \
&&  apt-get clean \
&&  rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*

# copy local files
COPY root/ /

# permissions
VOLUME /config	/libraries