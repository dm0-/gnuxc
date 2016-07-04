procps-ng               := procps-ng-3.3.11
procps-ng_sha1          := 1bdca65547df9ed019bd83649b0f8b8eaa017e25
procps-ng_url           := http://prdownloads.sourceforge.net/procps-ng/$(procps-ng).tar.xz

$(prepare-rule):
	$(call apply,drop-proc-self)

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-examples \
		--disable-rpath \
		--disable-silent-rules \
		--enable-{kill,pidof,skill} \
		--enable-oomem \
		--enable-modern-top \
		--enable-numa \
		--enable-sigwinch \
		--enable-w-from \
		--enable-watch8bit \
		--enable-wide-{memory,percent} \
		--with-ncurses \
		\
		--disable-libselinux \
		--without-systemd

$(build-rule):
# Avoid broken includes.
	$(MAKE) -C $(builddir) slabtop.o top/top.o CPPFLAGS='$$(NCURSES_CFLAGS)'
# Avoid non-portable code.
	$(MAKE) -C $(builddir) lib/nsutils.o && $(TOUCH) $(builddir)/lib/test_process{.o,}
# Build everything else normally.
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,ncurses)
	$(MAKE) -C $(builddir) install
