#!/bin/bash -ex

#get script location
SCRIPTDIR=`dirname $0`
SCRIPTDIR=`(cd $SCRIPTDIR ; pwd)`

VERSION=$1
if [[ -z "$VERSION" ]]; then
    for VERSION in jessie sid; do
        . ${SCRIPTDIR}/build_common.sh ${VERSION}
    done
    docker tag -f mickaelguene/arm64-debian:sid mickaelguene/arm64-debian:latest
else
    . ${SCRIPTDIR}/build_common.sh ${VERSION}
fi

