flex                    := flex-2.5.39
flex_url                := http://prdownloads.sourceforge.net/flex/$(flex).tar.bz2

configure-flex-rule:
	cd $(flex) && ./$(configure) \
		--disable-rpath

build-flex-rule:
	$(MAKE) -C $(flex) all

install-flex-rule: $(call installed,glibc)
	$(MAKE) -C $(flex) install \
		TEXI2DVI=:
	test -e $(DESTDIR)/usr/bin/lex || $(SYMLINK) flex $(DESTDIR)/usr/bin/lex
