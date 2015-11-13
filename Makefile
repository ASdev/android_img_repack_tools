CC=gcc -I. -DANDROID
AR=ar
RM=rm
ECHO=echo
CFLAGS=-DHOST -Icore/include -Icore/libsparse/include -Icore/libsparse -Ilibselinux/include
LDFLAGS=-L.
LIBS=-lz
LOCAL_LDLIBS=-llog
LIBZ=-lsparse -lselinux -lpcre -lcutils -lmincrypt
SELINUX_SRCS= \
	libselinux/src/booleans.c \
	libselinux/src/canonicalize_context.c \
	libselinux/src/disable.c \
	libselinux/src/enabled.c \
	libselinux/src/fgetfilecon.c \
	libselinux/src/fsetfilecon.c \
	libselinux/src/getenforce.c \
	libselinux/src/getfilecon.c \
	libselinux/src/getpeercon.c \
	libselinux/src/lgetfilecon.c \
	libselinux/src/load_policy.c \
	libselinux/src/lsetfilecon.c \
	libselinux/src/policyvers.c \
	libselinux/src/procattr.c \
	libselinux/src/setenforce.c \
	libselinux/src/setfilecon.c \
	libselinux/src/context.c \
	libselinux/src/mapping.c \
	libselinux/src/stringrep.c \
	libselinux/src/compute_create.c \
	libselinux/src/compute_av.c \
	libselinux/src/avc.c \
	libselinux/src/avc_internal.c \
	libselinux/src/avc_sidtab.c \
	libselinux/src/get_initial_context.c \
	libselinux/src/checkAccess.c \
	libselinux/src/sestatus.c \
	libselinux/src/deny_unknown.c
SELINUX_HOST= \
	libselinux/src/callbacks.c \
	libselinux/src/check_context.c \
	libselinux/src/freecon.c \
	libselinux/src/init.c \
	libselinux/src/label.c \
	libselinux/src/label_file.c \
	libselinux/src/label_android_property.c
ZLIB_SRCS= \
	zlib/src/adler32.c \
	zlib/src/compress.c \
	zlib/src/crc32.c \
	zlib/src/deflate.c \
	zlib/src/gzclose.c \
	zlib/src/gzlib.c \
	zlib/src/gzread.c \
	zlib/src/gzwrite.c \
	zlib/src/infback.c \
	zlib/src/inflate.c \
	zlib/src/inftrees.c \
	zlib/src/inffast.c \
	zlib/src/trees.c \
	zlib/src/uncompr.c \
	zlib/src/zutil.c
LIBMINCRYPT_SRCS= core/libmincrypt/*.c
LIBSPARSE_SRCS= \
	core/libsparse/backed_block.c \
	core/libsparse/output_file.c \
	core/libsparse/sparse.c \
	core/libsparse/sparse_crc32.c \
	core/libsparse/sparse_err.c \
	core/libsparse/sparse_read.c
EXT4FS_SRCS= \
    extras/ext4_utils/make_ext4fs.c \
    extras/ext4_utils/ext4fixup.c \
    extras/ext4_utils/ext4_utils.c \
    extras/ext4_utils/allocate.c \
    extras/ext4_utils/contents.c \
    extras/ext4_utils/extent.c \
    extras/ext4_utils/indirect.c \
    extras/ext4_utils/sha1.c \
    extras/ext4_utils/wipe.c \
    extras/ext4_utils/crc16.c \
    extras/ext4_utils/ext4_sb.c
EXT4FS_MAIN= \
    extras/ext4_utils/make_ext4fs_main.c \
    extras/ext4_utils/canned_fs_config.c
EXT4FS_DEF_SRCS= \
    extras/ext4_utils/make_ext4fs_def.c \
    extras/ext4_utils/ext4fixup.c \
    extras/ext4_utils/ext4_utils.c \
    extras/ext4_utils/allocate.c \
    extras/ext4_utils/contents.c \
    extras/ext4_utils/extent.c \
    extras/ext4_utils/indirect.c \
    extras/ext4_utils/sha1.c \
    extras/ext4_utils/wipe.c \
    extras/ext4_utils/crc16.c \
    extras/ext4_utils/ext4_sb.c
LIBCUTILS_SRCS= \
	core/libcutils/hashmap.c \
	core/libcutils/native_handle.c \
	core/libcutils/config_utils.c \
	core/libcutils/load_file.c \
	core/libcutils/strlcpy.c \
	core/libcutils/open_memstream.c \
	core/libcutils/strdup16to8.c \
	core/libcutils/strdup8to16.c \
	core/libcutils/record_stream.c \
	core/libcutils/process_name.c \
	core/libcutils/threads.c \
	core/libcutils/sched_policy.c \
	core/libcutils/iosched_policy.c \
	core/libcutils/str_parms.c \
	core/libcutils/fs_config.c

all: \
	libselinux \
	libpcre \
	libz \
	libmincrypt \
	libsparse \
	libcutils \
	simg2img \
	simg2simg \
	img2simg \
	make_ext4fs \
	make_ext4fs_def \
	ext2simg \
	mkbootfs \
	mkbootimg \
	unpackbootimg \
	sgs4ext4fs

.PHONY: libselinux

libselinux:
	@$(ECHO) "Building libselinux..."
	@$(CC) -c $(SELINUX_SRCS) $(CFLAGS) $(SELINUX_HOST)
	@$(AR) cqs $@.a *.o
	@$(RM) -rfv *.o
	@$(ECHO) "*******************************************"
	
libpcre:
	@$(ECHO) "Building libpcre..."
	@$(AR) cqs $@.a pcre/*.o
	@$(RM) -rfv *.o
	@$(ECHO) "*******************************************"
	
libz:
	@$(ECHO) "Building zlib_host..."
	@$(CC) -c $(ZLIB_SRCS) $(CFLAGS)
	@$(AR) cqs $@.a *.o
	@$(RM) -rfv *.o
	@$(ECHO) "*******************************************"
	
libmincrypt:
	@$(ECHO) "Building libmincrypt_host..."
	@$(CC) -c $(LIBMINCRYPT_SRCS) $(CFLAGS)
	@$(AR) cqs $@.a *.o
	@$(RM) -rfv *.o
	@$(ECHO) "*******************************************"
	
libcutils:
	@$(ECHO) "Building libcutils_host..."
	@$(CC) -c $(LIBCUTILS_SRCS) $(CFLAGS) $(LIBZ)
	@$(AR) cqs $@.a *.o
	@$(RM) -rfv *.o
	@$(ECHO) "*******************************************"

mkbootimg:
	@$(ECHO) "Building mkbootimg..."
	@$(CC) external/android_system_core/mkbootimg/mkbootimg.c -o $@ $(CFLAGS) $(LDFLAGS) $(LIBS) $(LIBZ)
	@$(ECHO) "*******************************************"
	
mkbootfs:
	@$(ECHO) "Building mkbootfs..."
	@$(CC) core/cpio/mkbootfs.c -o $@  $(CFLAGS) $(LDFLAGS) $(LIBS) $(LIBZ) $(LOCAL_LDLIBS)
	@$(ECHO) "*******************************************"

libsparse:
	@$(ECHO) "Building libsparse_host..."
	@$(ECHO) "*******************************************"
	@$(CC) -c core/libsparse/*.c $(CFLAGS)
	@$(AR) -x libz.a
	@$(AR) cqs $@.a *.o
	@$(RM) -rf *.o
	@$(ECHO) "*******************************************"
	
simg2img:
	@$(ECHO) "Building simg2img..."
	@$(CC) core/libsparse/simg2img.c -o $@ $(LIBSPARSE_SRCS) $(CFLAGS) $(LIBS)
	@$(ECHO) "*******************************************"
	
simg2simg:
	@$(ECHO) "Building simg2simg..."
	@$(CC) core/libsparse/simg2simg.c -o $@ $(LIBSPARSE_SRCS) $(CFLAGS) $(LIBS)
	@$(ECHO) "*******************************************"
	
img2simg:
	@$(ECHO) "Building img2simg..."
	@$(CC) core/libsparse/img2simg.c -o $@ $(LIBSPARSE_SRCS) $(CFLAGS) $(LIBS)
	@$(ECHO) "*******************************************"
	
make_ext4fs:
	@$(ECHO) "Building make_ext4fs..."
	@$(CC) -o $@ $(EXT4FS_MAIN) $(EXT4FS_SRCS) $(CFLAGS) $(LDFLAGS) $(LIBS) $(LIBZ) $(LOCAL_LDLIBS)
	@$(ECHO) "*******************************************"
	
make_ext4fs_def:
	@$(ECHO) "Building make_ext4fs_def..."
	@$(CC) -o $@ $(EXT4FS_MAIN) $(EXT4FS_DEF_SRCS) $(CFLAGS) $(LDFLAGS) $(LIBS) $(LIBZ) $(LOCAL_LDLIBS)
	@$(ECHO) "*******************************************"
	
ext2simg:
	@$(ECHO) "Building ext2simg..."
	@$(CC) -o $@ extras/ext4_utils/ext2simg.c $(EXT4FS_SRCS) $(CFLAGS) $(LDFLAGS) $(LIBS) $(LIBZ)
	@$(ECHO) "*******************************************"
	
unpackbootimg:
	@$(ECHO) "Building unpackbootimg..."
	@$(CC) external/android_system_core/mkbootimg/unpackbootimg.c -o $@ $(CFLAGS) $(LDFLAGS) $(LIBS) $(LIBZ)
	@$(RM) -rfv *.a
	@$(ECHO) "*******************************************"

sgs4ext4fs:
	@$(ECHO) "Building sgs4ext4fs..."
	@$(CC) external/sgs4ext4fs/main.c -o $@
	@$(ECHO) "*******************************************"
	
.PHONY:

clean:
	@$(ECHO) "Cleaning..."
	@$(RM) -rfv *.o *.a \
	libmincrypt \
	mkbootimg \
	mkbootfs \
	unpackbootimg \
	libsparse_host \
	simg2img \
	simg2simg \
	img2simg \
	make_ext4fs \
	make_ext4fs_def \
	ext2simg \
	sgs4ext4fs

	@$(ECHO) "*******************************************"
	
.PHONY:

clear:
	@$(ECHO) "Clearing..."
	@$(RM) -rfv *.o *.a *.sh
	@$(RM) -drfv \
	core \
	extras \
	libselinux \
	zlib \
	external \
	pcre
