#!/usr/bin/with-contenv bash

# 设定subfinder定时查找字幕
# 启动subfinder查找字幕
exec \
	s6-setuidgid abc \
	subfinder /media \
	-c /config/subfinder.json
