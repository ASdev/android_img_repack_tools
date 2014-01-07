CC=gcc -I. -DANDROID
AR=ar
RM=rm
ECHO=echo
CFLAGS=-DHOST -Icore/include -Icore/libsparse/include -Icore/libsparse -Icore/mkbootimg
LDFLAGS=-L.
LIBS=-lz
LIBZ=-lsparse_host
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
    extras/ext4_utils/wipe.c

all: \
	libz \
	libmincrypt_host \
	mkbootimg mkbootfs \
	libsparse_host \
	simg2img \
	simg2simg \
	img2simg \
	make_ext4fs \
	ext2simg \
	unpackbootimg \
	sgs4ext4fs

libz:
	@$(ECHO) "Building zlib_host..."
	@$(CC) -c $(ZLIB_SRCS) $(CFLAGS)
	@$(AR) cqs $@.a *.o
	@$(RM) -rf *.o
	@$(ECHO) "*******************************************"

libmincrypt_host:
	@$(ECHO) "Building libmincrypt_host..."
	@$(CC) -c $(LIBMINCRYPT_SRCS) $(CFLAGS)
	@$(AR) cqs $@.a *.o
	@$(RM) -rf *.o
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
	@$(CC) -o $@ extras/ext4_utils/make_ext4fs_main.c $(EXT4FS_SRCS) $(CFLAGS) $(LDFLAGS) $(LIBS) $(LIBZ)
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
	@$(RM) -rfv *.o *.a *.sh \
	libmincrypt \
	mkbootimg \
	mkbootfs \
	unpackbootimg \
	libsparse_host \
	simg2img \
	simg2simg \
	img2simg \
	make_ext4fs \
	ext2simg \
	sgs4ext4fs

	@$(ECHO) "*******************************************"
	
.PHONY:

clear:
	@$(ECHO) "Clearing..."
	@$(RM) -rfv *.o *.a
	@$(RM) -drfv \
	core \
	extras \
	zlib \
	external
