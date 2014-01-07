CC=gcc -I. -DANDROID
AR=ar
RM=rm
ECHO=echo
CFLAGS=-DHOST -Icore/include -Icore/libsparse/include -Icore/libsparse -Icore/mkbootimg
LDFLAGS=-L.
LIBS=-lz
ZLIB_SRCS= \
	zlib/adler32.c \
	zlib/compress.c \
	zlib/crc32.c \
	zlib/deflate.c \
	zlib/gzclose.c \
	zlib/gzlib.c \
	zlib/gzread.c \
	zlib/gzwrite.c \
	zlib/infback.c \
	zlib/inflate.c \
	zlib/inftrees.c \
	zlib/inffast.c \
	zlib/trees.c \
	zlib/uncompr.c \
	zlib/zutil.c
LIBMINCRYPT_SRCS= core/libmincrypt/*.c
EXT4FS_SRCS= \
	extras/ext4_utils/make_ext4fs.c \
	extras/ext4_utils/ext4fixup.c \
	extras/ext4_utils/ext4_utils.c \
	extras/ext4_utils/allocate.c \
	extras/ext4_utils/backed_block.c \
	extras/ext4_utils/output_file.c \
	extras/ext4_utils/contents.c \
	extras/ext4_utils/extent.c \
	extras/ext4_utils/indirect.c \
	extras/ext4_utils/uuid.c \
	extras/ext4_utils/sha1.c \
	extras/ext4_utils/sparse_crc32.c \
	extras/ext4_utils/wipe.c

all: \
	libz \
	libmincrypt_host \
	mkbootimg \
	mkbootfs \
	simg2img \
	make_ext4fs \
	ext2simg \
	unpackbootimg

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

simg2img:
	@$(ECHO) "Building simg2img..."
	@$(CC) extras/ext4_utils/simg2img.c -o $@ $(EXT4FS_SRCS) $(CFLAGS) $(LIBS)
	@$(ECHO) "*******************************************"
	
make_ext4fs:
	@$(ECHO) "Building make_ext4fs..."
	@$(CC) -o $@ extras/ext4_utils/make_ext4fs_main.c $(EXT4FS_SRCS) $(CFLAGS) $(LDFLAGS) $(LIBS)
	@$(ECHO) "*******************************************"
	
ext2simg:
	@$(ECHO) "Building ext2simg..."
	@$(CC) -o $@ extras/ext4_utils/ext2simg.c $(EXT4FS_SRCS) $(CFLAGS) $(LDFLAGS) $(LIBS)
	@$(ECHO) "*******************************************"

unpackbootimg:
	@$(ECHO) "Building unpackbootimg..."
	@$(CC) external/android_system_core/mkbootimg/unpackbootimg.c -o $@ $(CFLAGS) $(LIBS) libmincrypt_host.a
	@$(RM) -rfv *.a
	@$(ECHO) "*******************************************"

.PHONY:

clean:
	@$(ECHO) "Cleaning..."
	@$(RM) -rfv *.o *.a *.sh \
	libmincrypt \
	mkbootimg \
	mkbootfs \
	unpackbootimg \
	simg2img \
	make_ext4fs \
	ext2simg

	@$(ECHO) "*******************************************"
	
.PHONY:

clear:
	@$(ECHO) "Clearing..."
	@$(RM) -rfv *.o *.a *.sh
	@$(RM) -drfv \
	core \
	extras \
	zlib \
	external
