gcal                    := gcal-3.6.3.34-dae6
gcal_url                := http://alpha.gnu.org/gnu/gcal/$(gcal).tar.xz

configure-gcal-rule:
	cd $(gcal) && ./$(configure) \
		--disable-rpath \
		--disable-silent-rules \
		--enable-assert \
		--enable-easc \
		--enable-threads=posix \
		--enable-unicode \
		--without-included-regex \
		CPPFLAGS="`$(NCURSES_CONFIG) --cflags`" \
		LIBS="`$(NCURSES_CONFIG) --libs` -lunistring"

build-gcal-rule:
	$(MAKE) -C $(gcal) all

install-gcal-rule: $(call installed,libunistring ncurses)
	$(MAKE) -C $(gcal) install
	test -e $(DESTDIR)/usr/bin/cal || $(SYMLINK) gcal $(DESTDIR)/usr/bin/cal
