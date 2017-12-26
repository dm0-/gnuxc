acl                     := acl-2.2.52
acl_key                 := 600CD204FBCEA418BD2CA74F154343260542DF34
acl_url                 := http://download.savannah.gnu.org/releases/acl/$(acl).src.tar.gz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--exec-prefix= \
		PLATFORM=gnu

$(build-rule):
	$(MAKE) -C $(builddir) \
		CPPFLAGS=-DPATH_MAX=4096

$(install-rule): $$(call installed,attr)
	$(MAKE) -C $(builddir) install install-lib install-dev \
		PKG_DEVLIB_DIR='$$(PKG_LIB_DIR)'
