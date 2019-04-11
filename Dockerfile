FROM alpine:latest

ENV PUID 1001
ENV PGID 1001
ENV PUSER beets
ENV PGROUP data
ENV BEETSDIR /config

COPY root /

RUN apk add --no-cache --virtual=build-dependencies --upgrade cmake g++ gcc git jpeg-dev libpng-dev openjpeg-dev make python3-dev && \
	apk add --no-cache --upgrade curl imagemagick nano python3 tar wget mysql-client shadow su-exec && \
	pip3 install --no-cache-dir -U pip beets requests pylast && \
	apk del --purge build-dependencies && \
	rm -rf /root/.cache /tmp/* && \
	addgroup -g $PGID $PGROUP && \
	adduser -D -G $PGROUP -u $PUID $PUSER && \
	mkdir -m 775 -p /config \
	/data/music \
	/log \
	/scripts && \
	chmod 755 /usr/local/bin/docker-entrypoint.sh /etc/crontabs/beets /scripts/beets_import.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

CMD ["crond", "-f", "-d", "8"]

VOLUME /config /data/music /log /scripts

WORKDIR /root
