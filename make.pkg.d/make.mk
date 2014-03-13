make                    := make-4.0
make_url                := http://ftp.gnu.org/gnu/make/$(make).tar.bz2

configure-make-rule:
	cd $(make) && ./$(configure) \
		--disable-rpath \
		--with-guile \
		\
		--without-customs \
		--without-dmalloc

build-make-rule:
	$(MAKE) -C $(make) all

install-make-rule: $(call installed,guile)
	$(MAKE) -C $(make) install
	test -e $(DESTDIR)/usr/bin/gmake || $(SYMLINK) make $(DESTDIR)/usr/bin/gmake
