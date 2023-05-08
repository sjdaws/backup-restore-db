#!/usr/bin/env bash

ARGS=${ARGS}
DB_NAMES=${DB_NAMES:-}
EXCLUDE_DBS=${EXCLUDE_DBS:-}
HISTORY=${HISTORY:-}
HOST=${HOST:-localhost}
PASSWORD=${PASSWORD:-}
PORT=${PORT:-5432}
USERNAME=${USERNAME:-postgres}

. ./postgres/install-client.sh
. ./generic/backup-setup.sh

# Get database list
if [ ! -z "${DB_NAMES}" ]; then
    databases=${DB_NAMES//,/ }
else
    databases=`PGPASSWORD="${PASSWORD}" psql --host="${HOST}" --port="${PORT}" --username="${USERNAME}" -c "SELECT datname FROM pg_database;" | grep "^\s" | grep -v "^\s*datname\s*$" | tr -d " "`
fi

echo -e "\nDatabase backup"
echo "-----------------------"

# Perform backup
for database in ${databases}; do
    # Exclude system databases and excludes list
    if [[ "${database}" != _* ]] && [[ "${database}" != "postgres" ]] && [[ "${database}" != "template0" ]] && [[ "${database}" != "template1" ]] && [ ! -n "${exclude_map[$database]}" ]; then
        echo "Dumping database: ${database}"
        PGPASSWORD="${PASSWORD}" pg_dump ${ARGS} --dbname="${database}" --host="${HOST}" --port="${PORT}" --username="${USERNAME}" > "/${FULL_DUMP_PATH}/${database}.sql"
        if [[ ${?} -ne 0 ]]; then
            EXIT_CODE=1
        fi
    else
        if [[ -n "${exclude_map[$database]}" ]]; then
            echo "Excluding database: ${database}"
        else
            echo "Skipping database: ${database}"
        fi
    fi
done

. ./generic/backup-cleanup.sh
