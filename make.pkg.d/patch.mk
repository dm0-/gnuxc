patch                   := patch-2.7.5
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
