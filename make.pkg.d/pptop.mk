pptop                   := pptop-0.1.1
pptop_snap              := 2014-01-01
pptop_url               := cvs://anonymous@cvs.sv.gnu.org/sources/hurdextras

$(prepare-rule):
	$(COPY) /usr/share/gettext/config.rpath $(builddir)/

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-rpath \
		--enable-threads=posix \
		CPPFLAGS="`$(NCURSES_CONFIG) --cflags`" \
		LIBS="`$(NCURSES_CONFIG) --libs`"

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,ncurses)
	$(MAKE) -C $(builddir) install \
		mkinstalldirs='$(MKDIR)'
	test -e $(DESTDIR)/usr/bin/top || $(SYMLINK) pptop $(DESTDIR)/usr/bin/top
