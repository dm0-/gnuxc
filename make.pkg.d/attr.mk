attr                    := attr-2.4.47
attr_key                := 600CD204FBCEA418BD2CA74F154343260542DF34
attr_url                := http://download.savannah.gnu.org/releases/attr/$(attr).src.tar.gz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--exec-prefix= \
		PLATFORM=gnu

$(build-rule):
	$(MAKE) -C $(builddir)

$(install-rule): $$(call installed,glibc)
	$(MAKE) -C $(builddir) install install-lib install-dev
