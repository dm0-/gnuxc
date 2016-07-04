patch                   := patch-2.7.5
patch_sha1              := 8fd8f8f8ba640d871bce1bd33c7fd5e2ebe03a1e
patch_url               := http://ftpmirror.gnu.org/patch/$(patch).tar.xz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules \
		--enable-gcc-warnings gl_cv_warn_c__Werror=no \
		--enable-merge \
		--enable-xattr \
		CPPFLAGS=-DPATH_MAX=4096

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,attr)
	$(MAKE) -C $(builddir) install
