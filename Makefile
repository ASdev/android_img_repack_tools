CC=gcc -I. -DANDROID
AR=ar
RM=rm
ECHO=echo
CFLAGS=-DHOST -Icore/include -Icore/libsparse/include -Icore/libsparse -Ilibselinux/include -Icore/mkbootimg
LDFLAGS=-L.
LIBS=-lz
LIBZ=-lsparse_host -lselinux -lpcre
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
    extras/ext4_utils/uuid.c \
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
    extras/ext4_utils/uuid.c \
    extras/ext4_utils/sha1.c \
    extras/ext4_utils/wipe.c \
    extras/ext4_utils/crc16.c \
    extras/ext4_utils/ext4_sb.c

all: \
	libselinux \
	libpcre \
	libz \
	libmincrypt_host \
	mkbootimg \
	mkbootfs \
	libsparse_host \
	simg2img \
	simg2simg \
	img2simg \
	make_ext4fs \
	make_ext4fs_def \
	ext2simg \
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
		
libmincrypt_host:
	@$(ECHO) "Building libmincrypt_host..."
	@$(CC) -c $(LIBMINCRYPT_SRCS) $(CFLAGS)
	@$(AR) cqs $@.a *.o
	@$(RM) -rfv *.o
	@$(ECHO) "*******************************************"
	
mkbootimg:
	@$(ECHO) "Building mkbootimg..."
	@$(CC) core/mkbootimg/mkbootimg.c -o $@ $(CFLAGS) $(LIBS) libmincrypt_host.a
	@$(ECHO) "*******************************************"
	
mkbootfs:
	@$(ECHO) "Building mkbootfs..."
	@$(CC) core/cpio/mkbootfs.c -o $@ $(CFLAGS) $(LIBS)
	@$(ECHO) "*******************************************"

libsparse_host:
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
	@$(CC) -o $@ $(EXT4FS_MAIN) $(EXT4FS_SRCS) $(CFLAGS) $(LDFLAGS) $(LIBS) $(LIBZ)
	@$(ECHO) "*******************************************"
	
make_ext4fs_def:
	@$(ECHO) "Building make_ext4fs_def..."
	@$(CC) -o $@ $(EXT4FS_MAIN) $(EXT4FS_DEF_SRCS) $(CFLAGS) $(LDFLAGS) $(LIBS) $(LIBZ)
	@$(ECHO) "*******************************************"
	
ext2simg:
	@$(ECHO) "Building ext2simg..."
	@$(CC) -o $@ extras/ext4_utils/ext2simg.c $(EXT4FS_SRCS) $(CFLAGS) $(LDFLAGS) $(LIBS) $(LIBZ)
	@$(ECHO) "*******************************************"
	
unpackbootimg:
	@$(ECHO) "Building unpackbootimg..."
	@$(CC) external/android_system_core/mkbootimg/unpackbootimg.c -o $@ $(CFLAGS) $(LIBS) libmincrypt_host.a
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
