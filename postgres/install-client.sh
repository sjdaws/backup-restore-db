#!/usr/bin/env bash

INSTALLED_VERSION=17
VERSION=${VERSION:-${INSTALLED_VERSION}}

if [[ "${VERSION}" =~ ${NUMERIC} ]] && [[ ${VERSION} -gt 0 ]] && [[ ${VERSION} -ne ${INSTALLED_VERSION} ]] ; then
    echo -e "\nInstalling version ${VERSION} of pg_dump"
    echo "-----------------------"

    apk del "postgresql-${INSTALLED_VERSION}-client"
    apk add --update "postgresql-${VERSION}-client"
    if [[ ${?} -ne 0 ]]; then
        EXIT_CODE=1
    fi
fi
