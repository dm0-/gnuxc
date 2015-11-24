e2fsprogs               := e2fsprogs-1.42.13
e2fsprogs_url           := http://prdownloads.sourceforge.net/e2fsprogs/$(e2fsprogs).tar.gz

$(prepare-rule):
	$(EDIT) 's/ REBOOT LINUX / REBOOT GNU /' $(builddir)/e2fsck/unix.c

$(configure-rule):
	cd $(builddir) && ./$(configure) \
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

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,glibc)
	$(MAKE) -C $(builddir) install install-libs \
		pkgconfigdir=/usr/lib/pkgconfig
