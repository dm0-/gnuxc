gcal                    := gcal-4
gcal_sha1               := 10415242747812a4c05dc618d59eb2b156b9fa74
gcal_url                := http://ftpmirror.gnu.org/gcal/$(gcal).tar.xz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-rpath \
		--disable-silent-rules \
		--enable-assert \
		--enable-easc \
		--enable-threads=posix \
		--enable-unicode \
		--without-included-regex \
		CPPFLAGS="`$(NCURSES_CONFIG) --cflags`" \
		LIBS="`$(NCURSES_CONFIG) --libs` -lunistring"

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,libunistring ncurses)
	$(MAKE) -C $(builddir) install
	test -e $(DESTDIR)/usr/bin/cal || $(SYMLINK) gcal $(DESTDIR)/usr/bin/cal
