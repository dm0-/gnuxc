flex                    := flex-2.6.4
flex_key                := 56C67868E93390AA1039AD1CE4B29C8D64885307
flex_url                := http://github.com/westes/flex/releases/download/$(flex:flex-%=v%)/$(flex).tar.lz

$(prepare-rule):
# Skip tests.
	$(EDIT) '/^SUBDIRS *=/,/^$$/{/tests/d;}' $(builddir)/Makefile.in

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-rpath \
		--enable-libfl \
		--enable-warnings

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,glibc)
	$(MAKE) -C $(builddir) install
	test -e $(DESTDIR)/usr/bin/lex || $(SYMLINK) flex $(DESTDIR)/usr/bin/lex
