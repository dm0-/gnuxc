acl                     := acl-2.2.52
acl_sha1                := 537dddc0ee7b6aa67960a3de2d36f1e2ff2059d9
acl_url                 := http://download.savannah.gnu.org/releases/acl/$(acl).src.tar.gz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--exec-prefix=

$(build-rule):
	$(MAKE) -C $(builddir) \
		CPPFLAGS=-DPATH_MAX=4096

$(install-rule): $$(call installed,attr)
	$(MAKE) -C $(builddir) install install-lib install-dev \
		PKG_DEVLIB_DIR='$$(PKG_LIB_DIR)'
