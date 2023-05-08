#!/usr/bin/env bash

ARGS=${ARGS}
BACKUP_FILE=${BACKUP_FILE:-}
DB_NAME=${DB_NAME:-}
DROP_FIRST=${DROP_FIRST:-}
HOST=${HOST:-localhost}
PASSWORD=${PASSWORD:-}
PORT=${PORT:-5432}
USERNAME=${USERNAME:-postgres}

. ./postgres/install-client.sh
. ./generic/restore-setup.sh

echo -e "\nDatabase restore"
echo "-----------------------"

# Perform restore    
echo "Restoring database: ${DB_NAME}"
if [ "$DROP_FIRST" == "true" ]; then
    PGPASSWORD="${PASSWORD}" dropdb ${ARGS} --host="${HOST}" --port="${PORT}" --username="${USERNAME}" --if-exists -f "${DB_NAME}"
    PGPASSWORD="${PASSWORD}" createdb ${ARGS} --host="${HOST}" --port="${PORT}" --username="${USERNAME}" "${DB_NAME}"
fi
PGPASSWORD="${PASSWORD}" psql ${ARGS} --dbname="${DB_NAME}" --host="${HOST}" --port="${PORT}" --username="${USERNAME}" < "${FULL_RESTORE_PATH}"
if [[ ${?} -ne 0 ]]; then
    EXIT_CODE=1
fi
