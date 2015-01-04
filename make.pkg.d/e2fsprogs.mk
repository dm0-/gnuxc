e2fsprogs               := e2fsprogs-1.42.12
e2fsprogs_url           := http://prdownloads.sourceforge.net/e2fsprogs/$(e2fsprogs).tar.gz

configure-e2fsprogs-rule:
	cd $(e2fsprogs) && ./$(configure) \
		--exec-prefix= \
		\
		--disable-fsck \
		--disable-rpath \
		--enable-blkid-debug \
		--enable-compression \
		--enable-elf-shlibs \
		--enable-htree \
		--enable-jbd-debug \
		--enable-quota \
		--enable-threads=posix \
		--enable-verbose-makecmds \
		--without-included-gettext

build-e2fsprogs-rule:
	$(MAKE) -C $(e2fsprogs) all

install-e2fsprogs-rule: $(call installed,glibc)
	$(MAKE) -C $(e2fsprogs) install install-libs \
		pkgconfigdir=/usr/lib/pkgconfig
