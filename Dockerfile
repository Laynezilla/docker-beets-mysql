FROM alpine:latest

ENV PUID 1001
ENV PGID 1001
ENV PUSER beets
ENV PGROUP data
ENV BEETSDIR /config

#COPY root/scripts/ /scripts/
#COPY root/etc/crontabs/beets /etc/crontabs/$PUSER
#COPY root/usr/local/bin/docker-entrypoint.sh /usr/local/bin/
COPY root /

RUN apk add --no-cache --virtual=build-dependencies --upgrade cmake g++ gcc git jpeg-dev libpng-dev openjpeg-dev make python3-dev su-exec && \
	apk add --no-cache --upgrade curl imagemagick nano python3 tar wget mysql-client && \
	pip3 install --no-cache-dir -U pip beets requests pylast && \
	apk del --purge build-dependencies && \
	rm -rf /root/.cache /tmp/* && \
	addgroup -g $PGID $PGROUP && \
	adduser -D -G $PGROUP -u $PUID $PUSER && \
	chmod +x /usr/local/bin/docker-entrypoint.sh && \
	mkdir -p /config /data/music /log /scripts && \
	chmod -R 755 /config /data/music /log /scripts

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

CMD ["crond", "-f", "-d", "8"]

VOLUME /config /data/music /log /scripts

WORKDIR /root
