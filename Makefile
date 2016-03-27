CC=gcc-5 -I. -DANDROID
AR=ar
RM=rm
ECHO=echo
CFLAGS = -DHOST -Icore/include -Icore/libsparse/include -Icore/libsparse -Ilibselinux/include -Icore/mkbootimg
DFLAGS = -Werror -Iandroid_suport_include
LIBC_FLAGS = -Ibionic/libc/include -Ibionic/libc/kernel/uapi -Ibionic/libc/kernel/uapi/asm-x86
LIBLOG_FLAGS = -DLIBLOG_LOG_TAG=1005 -DFAKE_LOG_DEVICE=1 
LDFLAGS = -L.
LIBZ = -lz
LIB_LOCAL = -lsparse -lselinux -lpcre -lcutils -llog -lmincrypt
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
	core/libcutils/record_stream.c \
	core/libcutils/process_name.c \
	core/libcutils/threads.c \
	core/libcutils/sched_policy.c \
	core/libcutils/iosched_policy.c \
	core/libcutils/str_parms.c \
	core/libcutils/fs_config.c
LIBLOG_SRCS= \
	core/liblog/uio.c \
	core/liblog/event_tag_map.c \
	core/liblog/fake_log_device.c \
	core/liblog/logprint.c
LIBLOG_HOST= \
	core/liblog/log_read.c \
	core/liblog/log_read_kern.c \
	core/liblog/logd_write_kern.c
LIBLOG_SRC= \
	core/liblog/logd_write.c

all: \
    libselinux \
    libz \
	libsparse \
	libpcre \
	libmincrypt \
	libcutils \
	liblog \
	mkbootimg \
	mkbootfs \
	unpackbootimg \
	simg2img \
	simg2simg \
	img2simg \
	append2simg \
	make_ext4fs \
	make_ext4fs_def \
	ext2simg \
	sgs4ext4fs

.PHONY: libselinux

libselinux:
	@$(ECHO) "Building libselinux..."
	@$(CROSS_COMPILE)$(CC) -c $(SELINUX_SRCS) $(CFLAGS) $(SELINUX_HOST) $(DFLAGS)
	@$(AR) cqs $@.a *.o
	@$(RM) -rfv *.o
	@$(ECHO) "*******************************************"
	
libpcre:
	@$(ECHO) "Building libpcre..."
	@$(AR) cqs $@.a pcre/dist/*.o
	@$(ECHO) "*******************************************"
	
libz:
	@$(ECHO) "Building zlib_host..."
	@$(AR) cqs $@.a zlib/src/*.o
	@$(ECHO) "*******************************************"
		
libsparse:
	@$(ECHO) "Building libsparse_host..."
	@$(ECHO) "*******************************************"
	@$(CROSS_COMPILE)$(CC) -c $(LIBSPARSE_SRCS) $(CFLAGS)
	@$(AR) -x libz.a
	@$(AR) cqs $@.a *.o
	@$(RM) -rfv *.o
	@$(ECHO) "*******************************************"
	
libmincrypt:
	@$(ECHO) "Building libmincrypt_host..."
	@$(CROSS_COMPILE)$(CC) -c $(LIBMINCRYPT_SRCS) $(CFLAGS) $(DFLAGS)
	@$(AR) cqs $@.a *.o
	@$(RM) -rfv *.o
	@$(ECHO) "*******************************************"
	
libcutils:
	@$(ECHO) "Building libcutils_host..."
	@$(CC) -c $(LIBCUTILS_SRCS) $(CFLAGS) $(LIB_LOCAL) $(DFLAGS)
	@$(AR) cqs $@.a *.o
	@$(RM) -rfv *.o
	@$(ECHO) "*******************************************"
	
liblog:
	@$(ECHO) "Building liblog_host..."
	@$(CROSS_COMPILE)$(CC) -c $(LIBLOG_SRCS) $(CFLAGS) $(LDFLAGS) $(LIB_LOCAL) $(DFLAGS)
	@$(CROSS_COMPILE)$(CC) -c $(LIBLOG_HOST) $(CFLAGS) $(LDFLAGS) $(DFLAGS) $(LIB_LOCAL) $(LIBC_FLAGS) $(DFLAGS)
	@$(CROSS_COMPILE)$(CC) -c $(LIBLOG_SRC) $(CFLAGS) $(LDFLAGS) $(DFLAGS) $(LIBLOG_FLAGS) 
	@$(AR) cqs $@.a *.o
	@$(RM) -rfv *.o
	@$(ECHO) "*******************************************"
	
mkbootimg:
	@$(ECHO) "Building mkbootimg..."
	@$(CC) external/android_system_core/mkbootimg/mkbootimg.c -o $@ $(CFLAGS) $(LDFLAGS) $(LIBZ) $(LIB_LOCAL)
	@$(ECHO) "*******************************************"
	
mkbootfs:
	@$(ECHO) "Building mkbootfs..."
	@$(CC) core/cpio/mkbootfs.c -o $@  $(CFLAGS) $(LDFLAGS) $(LIBZ) $(LIB_LOCAL)
	@$(ECHO) "*******************************************"

simg2img:
	@$(ECHO) "Building simg2img..."
	@$(CROSS_COMPILE)$(CC) core/libsparse/simg2img.c -o $@ $(LIBSPARSE_SRCS) $(CFLAGS) $(LIBZ)
	@$(ECHO) "*******************************************"
	
simg2simg:
	@$(ECHO) "Building simg2simg..."
	@$(CROSS_COMPILE)$(CC) core/libsparse/simg2simg.c -o $@ $(LIBSPARSE_SRCS) $(CFLAGS) $(LIBZ)
	@$(ECHO) "*******************************************"
	
img2simg:
	@$(ECHO) "Building img2simg..."
	@$(CROSS_COMPILE)$(CC) core/libsparse/img2simg.c -o $@ $(LIBSPARSE_SRCS) $(CFLAGS) $(LIBZ)
	@$(ECHO) "*******************************************"
	
append2simg:
	@$(ECHO) "Building append2simg..."
	@$(CROSS_COMPILE)$(CC) core/libsparse/append2simg.c -o $@ $(LIBSPARSE_SRCS) $(CFLAGS) $(LIBZ)
	@$(ECHO) "*******************************************"
	
make_ext4fs:
	@$(ECHO) "Building make_ext4fs..."
	@$(CROSS_COMPILE)$(CC) -o $@ $(EXT4FS_MAIN) $(EXT4FS_SRCS) $(LIB_LOCAL) $(CFLAGS) $(LDFLAGS)
	@$(ECHO) "*******************************************"

make_ext4fs_def:
	@$(ECHO) "Building make_ext4fs_def..."
	@$(CROSS_COMPILE)$(CC) -o $@ $(EXT4FS_MAIN) $(EXT4FS_DEF_SRCS) $(LIB_LOCAL) $(CFLAGS) $(LDFLAGS)
	@$(ECHO) "*******************************************"
		
ext2simg:
	@$(ECHO) "Building ext2simg..."
	@$(CROSS_COMPILE)$(CC) -o $@ extras/ext4_utils/ext2simg.c $(EXT4FS_SRCS) $(CFLAGS) $(LDFLAGS) $(LIB_LOCAL)
	@$(ECHO) "*******************************************"
	
unpackbootimg:
	@$(ECHO) "Building unpackbootimg..."
	@$(CROSS_COMPILE)$(CC) external/android_system_core/mkbootimg/unpackbootimg.c -o $@ $(CFLAGS) $(LDFLAGS) $(LIB_LOCAL)
	@$(ECHO) "*******************************************"

sgs4ext4fs:
	@$(ECHO) "Building sgs4ext4fs..."
	@$(CROSS_COMPILE)$(CC) external/sgs4ext4fs/main.c -o $@
	@$(ECHO) "*******************************************"
	
	@$(ECHO) "Cleaning..."
	@$(RM) -rfv *.a

.PHONY:

clean:
	@$(ECHO) "Cleaning..."
	@$(RM) -rfv *.o *.a *img *fs
	

	@$(ECHO) "*******************************************"
	
.PHONY:

clear:
	@$(ECHO) "Clearing..."
	@$(RM) -rfv *.o *.a mkuserimg.sh file_contexts simg_dump.py
	@$(RM) -drfv \
	core \
	extras \
	libselinux \
	zlib \
	external \
	pcre \
	sepolicy \
	bionic

	@$(ECHO) "*******************************************"
	
