#!/usr/bin/env bash

ARGS=${ARGS}
BACKUP_FILE=${BACKUP_FILE:-}
DB_NAME=${DB_NAME:-}
DROP_FIRST=${DROP_FIRST:-}
HOST=${HOST:-localhost}
PASSWORD=${PASSWORD:-}
PORT=${PORT:-3306}
USERNAME=${USERNAME:-root}

. ./generic/restore-setup.sh

PASSWORD_PATH=/tmp

# Create password file
echo -e "[client]\npassword=${PASSWORD}" > "${PASSWORD_PATH}/.my.cnf"
chmod 600 /tmp/.my.cnf

echo -e "\nDatabase restore"
echo "-----------------------"

# Perform restore    
echo "Restoring database: ${DB_NAME}"
if [ "$DROP_FIRST" == "true" ]; then
    mysql --defaults-extra-file="${PASSWORD_PATH}/.my.cnf" ${ARGS} --host="${HOST}" --port="${PORT}" --user="${USERNAME}" -e "DROP DATABASE IF EXISTS ${DB_NAME};"
    mysql --defaults-extra-file="${PASSWORD_PATH}/.my.cnf" ${ARGS} --host="${HOST}" --port="${PORT}" --user="${USERNAME}" -e "CREATE DATABASE ${DB_NAME};"
fi
mysql --defaults-extra-file="${PASSWORD_PATH}/.my.cnf" ${ARGS} --database="${DB_NAME}" --host="${HOST}" --port="${PORT}" --user="${USERNAME}" < "${FULL_RESTORE_PATH}"
if [[ ${?} -ne 0 ]]; then
    EXIT_CODE=1
fi
    
# Clean up passwords file
rm -f "${PASSWORD_PATH}/.my.cnf"
