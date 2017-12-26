make                    := make-4.2.1
make_key                := 3D2554F0A15338AB9AF1BB9D96B047156338B6D4
make_url                := http://ftpmirror.gnu.org/make/$(make).tar.bz2

$(eval $(call verify-download,update-guile.patch,http://git.savannah.gnu.org/cgit/make.git/patch/?id=fbf71ec25a5986d9003ac16ee9e23675feac9053,fd4286fe4d25b9e5dba623674b23a6c7dcbcef12))

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
