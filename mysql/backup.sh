#!/usr/bin/env bash

ARGS=${ARGS}
DB_NAMES=${DB_NAMES:-}
EXCLUDE_DBS=${EXCLUDE_DBS:-}
HISTORY=${HISTORY:-}
HOST=${HOST:-localhost}
PASSWORD=${PASSWORD:-}
PORT=${PORT:-3306}
USERNAME=${USERNAME:-root}

. ./generic/backup-setup.sh

PASSWORD_PATH=/tmp

# Create password file
echo -e "[client]\npassword=${PASSWORD}" > "${PASSWORD_PATH}/.my.cnf"
chmod 600 /tmp/.my.cnf

# Get database list
if [ ! -z "${DB_NAMES}" ]; then
    databases=${DB_NAMES//,/ }
else
    databases=`mysql --defaults-extra-file="${PASSWORD_PATH}/.my.cnf" --host="${HOST}" --port="${PORT}" --user="${USERNAME}" -e "SHOW DATABASES;" | tr -d "| " | grep -v "^Database$"`
fi

echo -e "\nDatabase backup"
echo "-----------------------"

# Perform backup
for database in ${databases}; do
    # Exclude system databases and excludes list
    if [[ "${database}" != _* ]] && [[ "${database}" != "information_schema" ]] && [[ "${database}" != "mysql" ]] && [[ "${database}" != "performance_schema" ]] && [ ! -n "${exclude_map[$database]}" ]; then
        echo "Dumping database: ${database}"
        mysqldump --defaults-extra-file="${PASSWORD_PATH}/.my.cnf" ${ARGS} --databases "${database}" --host="${HOST}" --port="${PORT}" --user="${USERNAME}" > "/${FULL_DUMP_PATH}/${database}.sql"
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

# Clean up passwords file
rm -f "${PASSWORD_PATH}/.my.cnf"

. ./generic/backup-cleanup.sh
