procps-ng               := procps-ng-3.3.12
procps-ng_sha1          := 82c0745f150f1385ca01fe7d24f05f74e31c94c6
procps-ng_url           := http://prdownloads.sourceforge.net/procps-ng/$(procps-ng).tar.xz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-examples \
		--disable-rpath \
		--disable-silent-rules \
		--enable-{kill,pidof,skill} \
		--enable-modern-top \
		--enable-numa \
		--enable-sigwinch \
		--enable-w-from \
		--enable-watch8bit \
		--enable-wide-{memory,percent} \
		--with-ncurses \
		CPPFLAGS=-DHOST_NAME_MAX=_POSIX_HOST_NAME_MAX \
		\
		--disable-libselinux \
		--without-systemd

$(build-rule):
# Avoid broken includes.
	$(MAKE) -C $(builddir) slabtop.o top/top.o CPPFLAGS='$$(NCURSES_CFLAGS)'
# Build everything else normally.
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,ncurses)
	$(MAKE) -C $(builddir) install
