#!/bin/bash -ex

VERSION=$1
if [[ -z "$VERSION" ]]; then
    echo "empty"
else
    echo $VERSION
fi

#get script location
SCRIPTDIR=`dirname $0`
SCRIPTDIR=`(cd $SCRIPTDIR ; pwd)`

. ${SCRIPTDIR}/build_common.sh

