#!/usr/bin/env bash

DUMP_PATH=/backup
NUMERIC='^[0-9]+$'

# Determine if password has been passed, but don't echo it to log
[[ "${PASSWORD}" != "" ]] && PASSWORD_SUPPLIED="Yes" || PASSWORD_SUPPLIED="No"

# Print variables for debugging
echo -e "\nEnvironment variables"
echo "-----------------------"
echo "ARGS: ${ARGS}"
echo "BACKUP_FILE: ${BACKUP_FILE}"
echo "DB_NAME: ${DB_NAME}"
echo "DROP_FIRST: ${DROP_FIRST}"
echo "HOST: ${HOST}"
echo "PASSWORD: ${PASSWORD_SUPPLIED}"
echo "PORT: ${PORT}"
echo "USERNAME: ${USERNAME}"
if [ ! -z "${VERSION}" ]; then
	echo "VERSION: ${VERSION}"
fi

FULL_RESTORE_PATH="${DUMP_PATH}/${BACKUP_FILE}"

# Check backup file
echo -e "\nFile check"
echo "-----------------------"
if [ -f "${FULL_RESTORE_PATH}" ] && [[ `wc -c "${FULL_RESTORE_PATH}" | awk '{print $1}'` -gt 0 ]]; then
	echo "Backup file ${BACKUP_FILE} looks good" 
else 
	echo "Backup file ${BACKUP_FILE} is inaccessible or zero-length, aborting before any damage is done"
	exit 1
fi

if [ -z "${DB_NAME}" ]; then
	echo "Database name not supplied, can't restore backup to nothing, aborting"
	exit 1
fi
