attr                    := attr-2.4.47
attr_url                := http://download.savannah.gnu.org/releases/attr/$(attr).src.tar.gz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--exec-prefix=

$(build-rule):
	$(MAKE) -C $(builddir)

$(install-rule): $$(call installed,glibc)
	$(MAKE) -C $(builddir) install install-lib install-dev
