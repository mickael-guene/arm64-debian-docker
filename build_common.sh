#!/bin/bash -ex

VERSION=$1
if [[ -z "$VERSION" ]]; then
    VERSION="sid"
else
    echo $VERSION
fi

function cleanup() {
    rm -Rf $TMPDIR
}

function build_multistrap() {
mkdir -p ${TMPDIR}/conf
cat << EOF > ${TMPDIR}/conf/multistrap.conf
[General]
noauth=true
unpack=true
debootstrap=Debian
aptsources=Debian

[Debian]
packages=apt
source=http://ftp.debian.org/debian
suite=${VERSION}
EOF
}

function build_configure_guest() {
mkdir -p ${TMPDIR}/scripts
cat << EOF > ${TMPDIR}/scripts/configure_guest.sh
#!/bin/bash -ex

export DEBIAN_FRONTEND=noninteractive
export DEBCONF_NONINTERACTIVE_SEEN=true
export LC_ALL=C LANGUAGE=C LANG=C
/var/lib/dpkg/info/dash.preinst install
dpkg --configure -a
EOF
chmod +x ${TMPDIR}/scripts/configure_guest.sh
}

#get script location
SCRIPTDIR=`dirname $0`
SCRIPTDIR=`(cd $SCRIPTDIR ; pwd)`

#create tmp dir
TMPDIR=`mktemp -d -t arm64_debian_docker_XXXXXXXX`
trap cleanup EXIT
cd ${TMPDIR}

#get umeq
mkdir -p ${TMPDIR}/tools
wget https://raw.githubusercontent.com/mickael-guene/umeq-static-build/master/bin/umeq-arm64 -O ${TMPDIR}/tools/umeq-arm64
chmod +x ${TMPDIR}/tools/umeq-arm64

#get arm64
build_multistrap
/usr/sbin/multistrap -a arm64 -d rootfs -f ${TMPDIR}/conf/multistrap.conf

#configure it
build_configure_guest
cp ${TMPDIR}/tools/umeq-arm64 ${TMPDIR}/rootfs/usr/bin/umeq-arm64
ln -rsf ${TMPDIR}/rootfs/usr/bin/umeq-arm64 ${TMPDIR}/rootfs/usr/bin/qemu-aarch64-static
tar --owner=root --group=root -c -C rootfs . | docker import - tmp_before_configuration
ID=`docker run -d -v ${TMPDIR}/scripts:/tmp/scripts tmp_before_configuration /tmp/scripts/configure_guest.sh`
docker wait $ID
docker commit $ID mickaelguene/arm64-debian:${VERSION}
docker rm $ID
docker rmi tmp_before_configuration

