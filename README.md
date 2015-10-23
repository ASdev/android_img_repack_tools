android_img_repack_tools
====================

android_img_repack_tools is a kit utilites for unpack/repack android ext4 and boot images

how to make:

step one: Install these packages:

android-liblog-dev                    https://packages.debian.org/jessie/android-liblog-dev

create link for lib

$ sudo ln /usr/lib/android/liblog.a /usr/local/lib/

step two: download the sources:

$ ./configure

step three run compile

$ make

will compille binaries:
mkbootfs
simg2simg
make_ext4fs
mkbootimg
sgs4ext4fs
unpackbootimg
ext2simg
img2simg
simg2img 

$ make clean

will clean sources

$ make clear

will remove sources

