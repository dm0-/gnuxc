e2fsprogs               := e2fsprogs-1.43.4
e2fsprogs_sha1          := f7cf8c82805103b53f89ad5da641e1085281d411
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
