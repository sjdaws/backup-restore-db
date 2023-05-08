#!/usr/bin/env bash

ARG=`echo "${@}" | tr '[:upper:]' '[:lower:]'`
EXIT_CODE=0

case "${ARG}" in
    "--mysql-backup")
        . ./mysql/backup.sh
    ;;

    "--mysql-restore")
        . ./mysql/restore.sh
    ;;

    "--postgres-backup")
        . ./postgres/backup.sh
    ;;

    "--postgres-restore")
        . ./postgres/restore.sh
    ;;

    *)
        echo "Not sure what to do with ${@}, so doing nothing"
        exit 1
    ;;
esac

[[ ${EXIT_CODE} -eq 0 ]] && echo -e "\nDone!" ||  echo -e "\nDone, with errors"

exit ${EXIT_CODE}