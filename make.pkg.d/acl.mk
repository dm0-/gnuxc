acl                     := acl-2.2.52
acl_url                 := http://download.savannah.gnu.org/releases/acl/$(acl).src.tar.gz

configure-acl-rule:
	cd $(acl) && ./$(configure) \
		--exec-prefix=

build-acl-rule:
	$(MAKE) -C $(acl) \
		CPPFLAGS=-DPATH_MAX=4096

install-acl-rule: $(call installed,attr)
	$(MAKE) -C $(acl) install install-lib install-dev \
		PKG_DEVLIB_DIR='$$(PKG_LIB_DIR)'
