attr                    := attr-2.4.47
attr_url                := http://download.savannah.gnu.org/releases/attr/$(attr).src.tar.gz

configure-attr-rule:
	cd $(attr) && ./$(configure) \
		--exec-prefix=

build-attr-rule:
	$(MAKE) -C $(attr)

install-attr-rule: $(call installed,glibc)
	$(MAKE) -C $(attr) install install-lib install-dev
