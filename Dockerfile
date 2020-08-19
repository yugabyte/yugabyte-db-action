FROM docker:stable

RUN set -eux ; \
    apk add  --no-cache bash
COPY entrypoint.sh /usr/bin/entrypoint
RUN chmod +x /usr/bin/entrypoint
ENTRYPOINT ["entrypoint"]
