#!/usr/bin/env bash

DUMP_PATH=/backup
NUMERIC='^[0-9]+$'

# Determine if password has been passed, but don't echo it to log
[[ "${PASSWORD}" != "" ]] && PASSWORD_SUPPLIED="Yes" || PASSWORD_SUPPLIED="No"

# Print variables for debugging
echo -e "\nEnvironment variables"
echo "-----------------------"
echo "ARGS: ${ARGS}"
echo "DB_NAMES: ${DB_NAMES}"
echo "EXCLUDE_DBS: ${EXCLUDE_DBS}"
echo "HISTORY: ${HISTORY}"
echo "HOST: ${HOST}"
echo "PASSWORD: ${PASSWORD_SUPPLIED}"
echo "PORT: ${PORT}"
echo "USERNAME: ${USERNAME}"
if [ ! -z "${VERSION}" ]; then
	echo "VERSION: ${VERSION}"
fi

# Determine folder
[[ "${DB_NAMES}" == "" ]] && SUFFIX="all" || SUFFIX="${DB_NAMES}"
FOLDER_PREFIX=${HOST}-${PORT}-${SUFFIX}
FULL_DUMP_PATH="${DUMP_PATH}/${FOLDER_PREFIX}-$(date +%Y%m%d%H%M%S)"
mkdir -p "${FULL_DUMP_PATH}"

# Determine excludes
declare -A exclude_map
IFS=',' read -ra excludes <<< "${EXCLUDE_DBS}"
for key in "${!excludes[@]}"; do exclude_map[${excludes[$key]}]="$key"; done
