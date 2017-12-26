fontconfig              := fontconfig-2.12.6
fontconfig_sha1         := cae963814ba4bc41f3c96876604d33fc3abfc572
fontconfig_url          := http://www.freedesktop.org/software/fontconfig/release/$(fontconfig).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-iconv \
		--enable-libxml2 \
		--enable-static
ifneq ($(host),$(build))
	$(EDIT) 's,$(sysroot),,g' $(builddir)/fontconfig.pc
endif

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,freetype libxml2)
	$(MAKE) -C $(builddir) install
