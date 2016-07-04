e2fsprogs               := e2fsprogs-1.43.1
e2fsprogs_sha1          := 26b75c27ba434e72ef630b160782a01b4d992b7a
e2fsprogs_url           := http://prdownloads.sourceforge.net/e2fsprogs/$(e2fsprogs).tar.gz

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
		--without-included-gettext \
		\
		CPPFLAGS=-DEUCLEAN=ED # Hurd doesn't define EUCLEAN.

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,glibc)
	$(MAKE) -C $(builddir) install install-libs \
		pkgconfigdir=/usr/lib/pkgconfig
