gcal                    := gcal-4.1
gcal_sha1               := 8ced243f2cca3910986a4649234fea5e40e80477
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
