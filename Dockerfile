FROM ghcr.io/linuxserver/baseimage-ubuntu:bionic

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="aptalca"

# environment variables
ARG DEBIAN_FRONTEND="noninteractive"
ENV PYTHON_EGG_CACHE="/config/plugins/.python-eggs"

# install software
RUN \
 echo "**** add repositories ****" && \
 apt-get update && \
 apt-get install -y \
	xz-utils \
	build-essential \
	python3 \
	python3-dev \
	python3-twisted \
	python3-openssl \
	python3-setuptools \
	intltool \
	python3-xdg \
	python3-chardet \
	geoip-database \
	python3-libtorrent \
	python-notify \
	python-pygame \
	python-glade2 \
	librsvg2-common \
	xdg-utils \
	python3-mako \
	p7zip-full \
	unrar \
	unzip && \
 echo "**** installing software ****" && \
 cd /tmp && \
 curl http://download.deluge-torrent.org/source/2.0/deluge-2.0.3.tar.xz -O && \
 ls && \
 tar -xf /tmp/deluge-2.0.3.tar.xz && \
 cd /tmp/deluge-2.0.3 && \
 cat RELEASE-VERSION && \
 python3 setup.py clean -a && \
 python3 setup.py build && \
 python3 setup.py install --install-layout=deb && \
 cd packaging/systemd && \

 echo "**** cleanup ****" && \
 cd / && \
 apt-get purge -y --auto-remove build-essential python3-dev && \
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*

# add local files
COPY root/ /

# ports and volumes
EXPOSE 8112 58846 58946 58946/udp
VOLUME /config /downloads
