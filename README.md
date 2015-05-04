 Here you can find build script use to build
[mickaelguene/arm64-debian](https://registry.hub.docker.com/u/mickaelguene/arm64-debian/)
docker image.

 This image embed [umeq](https://github.com/mickael-guene/umeq) so you can use it on a x86_64
machine with binfmt_misc support enable.

## Usage
 Just use `FROM mickaelguene/arm64-debian:<VERSION>` in your Dockerfile do use it as
a base image.

 You can also test it with a bash prompt:

    sudo docker pull mickaelguene/arm64-debian:<VERSION>
    sudo docker run -i -t mickaelguene/arm64-debian:<VERSION> /bin/bash


## Building

 You can rebuild on an x86_64 machine by calling build.sh script

## Emulation support

 All the above will work if you have binfmt_misc support enable and configure

### Setup binfmt_misc the easy way

 If you use a debian base distro then just install needed packages
 
    sudo apt-get install qemu binfmt-support qemu-user-static

### Setup binfmt_misc the hard way

 I have not tested all following commands so it might failed.
 
 First mount binfmt_misc file system

    sudo mount binfmt_misc -t binfmt_misc /proc/sys/fs/binfmt_misc

 Then configure support for aarch64

    sudo sh -c 'echo "umeq-arm64:M::\x7fELF\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\xb7:\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff:/usr/bin/umeq-arm64:" > /proc/sys/fs/binfmt_misc/register'
