make                    := make-4.2.1
make_sha1               := 7d9d11eb36cfb752da1fb11bb3e521d2a3cc8830
make_url                := http://ftpmirror.gnu.org/make/$(make).tar.bz2

$(eval $(call verify-download,http://git.savannah.gnu.org/cgit/make.git/patch/?id=fbf71ec25a5986d9003ac16ee9e23675feac9053,fd4286fe4d25b9e5dba623674b23a6c7dcbcef12,update-guile.patch))

$(prepare-rule):
# Support Guile 2.2 integration.
	$(PATCH) -d $(builddir) -p1 < $(call addon-file,update-guile.patch)
	$(RM) $(builddir)/configure

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
