#!/usr/bin/env bash

echo -e "\nHistory cleanup"
echo "-----------------------"

if [[ ${EXIT_CODE} -ne 0 ]]; then
    echo "Not performing cleanup as backup failed"
    rm -Rf "${FULL_DUMP_PATH}"
elif [ -z "${HISTORY}" ] || [[ ! "${HISTORY}" =~ ${NUMERIC} ]] || [[ ${HISTORY} -le 0 ]] ; then
    [ -z "${HISTORY}" ] && echo "Not performing cleanup, history variable not specified" || echo "Not performing cleanup, history variable is invalid"
    echo ""
else
    COUNTER=1
    for folder in `find ${DUMP_PATH} -type d -name "${FOLDER_PREFIX}-*" | sort -nr`; do
        if [[ ${COUNTER} -le ${HISTORY} ]]; then
            if [[ "${folder}" == "${FULL_DUMP_PATH}" ]]; then
                echo "Keeping: ${folder##*\/} (${COUNTER}/${HISTORY}) <-- This backup"
            else
                echo "Keeping: ${folder##*\/} (${COUNTER}/${HISTORY})"
            fi
            COUNTER=$((COUNTER+1))
        else
            echo "Removing: ${folder##*\/}"
            rm -Rf ${folder}
        fi
    done
fi