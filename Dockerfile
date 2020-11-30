FROM lsiobase/alpine:3.12 as builder
# set label
LABEL maintainer="NG6"
ARG S6_VER=2.1.0.2
WORKDIR /downloads
# download s6-overlay
RUN	if [ "$(uname -m)" = "x86_64" ];then s6_arch=amd64;elif [ "$(uname -m)" = "aarch64" ];then s6_arch=aarch64;elif [ "$(uname -m)" = "armv7l" ];then s6_arch=arm; fi  \
&&  wget --no-check-certificate https://github.com/just-containers/s6-overlay/releases/download/v${S6_VER}/s6-overlay-${s6_arch}.tar.gz  \
&&	mkdir ./s6-overlay \
&&  tar -xvzf s6-overlay-${s6_arch}.tar.gz -C ./s6-overlay	

FROM python:3.8-slim-buster
# set label
LABEL maintainer="NG6"
ENV TZ=Asia/Shanghai TASK=1d PUID=1026 PGID=100
# copy files
COPY root/ /
COPY --from=builder /downloads/s6-overlay/  /
# install subfinder
RUN apt -y update && apt -y install unrar-free \
&&  pip install subfinder \
&&  useradd -u 1000 -U -d /config -s /bin/false abc \
&&  usermod -G users abc  \
&&  echo "**** cleanup ****" \
&&  apt-get clean \
&&	apt-get autoremove \
&&  rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*
	
# volumes
VOLUME /config	/media
