#!/usr/bin/env bash

INSTALLED_VERSION=18
VERSION=${VERSION:-${INSTALLED_VERSION}}

if [[ "${VERSION}" =~ ${NUMERIC} ]] && [[ ${VERSION} -gt 0 ]] && [[ ${VERSION} -ne ${INSTALLED_VERSION} ]] ; then
    echo -e "\nInstalling version ${VERSION} of pg_dump"
    echo "-----------------------"

    apt-get update
    apt-get remove -y postgresql-client-${INSTALLED_VERSION}
    apt autoremove -y
    apt-get install -y postgresql-client-${VERSION}
    if [[ ${?} -ne 0 ]]; then
        EXIT_CODE=1
    fi
fi
