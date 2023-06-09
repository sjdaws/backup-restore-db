FROM alpine

RUN apk add --update bash mysql-client postgresql15-client && \
  rm -rf /var/cache/apk/*

COPY --chmod=755 generic /app/generic
COPY --chmod=755 mysql /app/mysql
COPY --chmod=755 postgres /app/postgres
COPY --chmod=755 run.sh /app

WORKDIR /app

ENTRYPOINT ["/app/run.sh"]
