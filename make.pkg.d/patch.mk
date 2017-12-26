patch                   := patch-2.7.5
patch_key               := 7768CE4B75E5236F1A374CEEC4C927CD5D1B36D7
patch_url               := http://ftpmirror.gnu.org/patch/$(patch).tar.xz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-gcc-warnings gl_cv_warn_c__Werror=no \
		--enable-merge \
		--enable-xattr \
		CPPFLAGS=-DPATH_MAX=4096

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,attr)
	$(MAKE) -C $(builddir) install
