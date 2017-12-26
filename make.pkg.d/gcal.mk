gcal                    := gcal-4.1
gcal_key                := AC404C1C0BF735C63FF4D562263D6DF2E163E1EA
gcal_url                := http://ftpmirror.gnu.org/gcal/$(gcal).tar.xz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-rpath \
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
