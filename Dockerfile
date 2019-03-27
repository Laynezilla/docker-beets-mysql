FROM alpine:latest

ENV PUID 1001
ENV PGID 1001
ENV PUSER beets
ENV PGROUP beets
ENV BEETSDIR /config

VOLUME ["/config", "/data/music", "/log", "/scripts"]

COPY root/etc/crontabs/beets /etc/crontabs/$PUSER
COPY root/scripts/beet_import.sh /scripts/beet_import.sh

RUN addgroup -g $PGID $PGROUP && \
	adduser -D -G $PGROUP -u $PUID $PUSER && \
	chmod 0600 /etc/crontabs/$PUSER
	chmod +x /scripts/beet_import.sh

RUN apk add --no-cache --virtual=build-dependencies --upgrade cmake g++ gcc git jpeg-dev libpng-dev openjpeg-dev make python3-dev && \
	apk add --no-cache --upgrade curl imagemagick nano python3 tar wget mysql-client && \
	pip3 install --no-cache-dir -U pip beets requests pylast && \
	apk del --purge build-dependencies && \
	rm -rf /root/.cache /tmp/*

CMD ["crond", "-f", "-d", "8"]

WORKDIR /home/$PUSER/
