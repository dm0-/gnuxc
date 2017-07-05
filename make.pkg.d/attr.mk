attr                    := attr-2.4.47
attr_sha1               := 5060f0062baee6439f41a433325b8b3671f8d2d8
attr_url                := http://download.savannah.gnu.org/releases/attr/$(attr).src.tar.gz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--exec-prefix= \
		PLATFORM=gnu

$(build-rule):
	$(MAKE) -C $(builddir)

$(install-rule): $$(call installed,glibc)
	$(MAKE) -C $(builddir) install install-lib install-dev
