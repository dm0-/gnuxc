make                    := make-4.2.1
make_sha1               := 7d9d11eb36cfb752da1fb11bb3e521d2a3cc8830
make_url                := http://ftpmirror.gnu.org/make/$(make).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-rpath \
		--with-guile \
		\
		--without-customs \
		--without-dmalloc

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,guile)
	$(MAKE) -C $(builddir) install
	test -e $(DESTDIR)/usr/bin/gmake || $(SYMLINK) make $(DESTDIR)/usr/bin/gmake
