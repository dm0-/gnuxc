e2fsprogs               := e2fsprogs-1.43.7
e2fsprogs_key           := 2B69B954DBFE0879288137C9F2F95956950D81A3
e2fsprogs_url           := http://prdownloads.sourceforge.net/e2fsprogs/$(e2fsprogs).tar.gz
e2fsprogs_sig           := $(e2fsprogs_url).asc

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--exec-prefix= \
		\
		--disable-fsck \
		--disable-rpath \
		--enable-{blkid,jbd,testio}-debug \
		--enable-elf-shlibs \
		--enable-libblkid \
		--enable-libuuid \
		--enable-threads=posix \
		--enable-verbose-makecmds \
		--without-included-gettext

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,glibc)
	$(MAKE) -C $(builddir) install install-libs \
		pkgconfigdir=/usr/lib/pkgconfig
