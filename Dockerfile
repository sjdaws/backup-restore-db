FROM ubuntu AS builder

# Set up postgres repo
RUN set -eux; \
  /usr/bin/apt update; \
  /usr/bin/apt-get install -y ca-certificates curl lsb-release; \
  /usr/bin/install -d /usr/share/postgresql-common/pgdg; \
  /usr/bin/curl -o /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc --fail https://www.postgresql.org/media/keys/ACCC4CF8.asc; \
  /bin/echo "deb [signed-by=/usr/share/postgresql-common/pgdg/apt.postgresql.org.asc] https://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list; \
  /usr/bin/apt-get remove -y ca-certificates curl lsb-release; \
  /usr/bin/apt autoremove -y; \
  /usr/bin/apt update

# Install clients
RUN set -eux; \
  /usr/bin/apt-get install -y mysql-client-8.0 postgresql-client-17

# Copy scripts
COPY --chmod=755 generic /app/generic
COPY --chmod=755 mysql /app/mysql
COPY --chmod=755 postgres /app/postgres
COPY --chmod=755 run.sh /app

WORKDIR /app

ENTRYPOINT ["/app/run.sh"]
