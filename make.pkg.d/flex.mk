flex                    := flex-2.6.0
flex_sha1               := 684c927c9f1b170e9627338de12e99cf2c224b91
flex_url                := http://prdownloads.sourceforge.net/flex/$(flex).tar.xz

$(prepare-rule):
# Skip tests.
	$(EDIT) '/^SUBDIRS *=/,/^$$/{/tests/d;}' $(builddir)/Makefile.in

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-rpath

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,glibc)
	$(MAKE) -C $(builddir) install
	test -e $(DESTDIR)/usr/bin/lex || $(SYMLINK) flex $(DESTDIR)/usr/bin/lex
