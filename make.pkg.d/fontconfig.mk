fontconfig              := fontconfig-2.12.0
fontconfig_sha1         := 4170b4d11816b10ff739e1b8ce35fae15a45894b
fontconfig_url          := http://www.freedesktop.org/software/fontconfig/release/$(fontconfig).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules \
		--enable-iconv \
		--enable-libxml2 \
		--enable-static \
		CPPFLAGS=-DPATH_MAX=4096
ifneq ($(host),$(build))
	$(EDIT) 's,$(sysroot),,g' $(builddir)/fontconfig.pc
endif

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,freetype libxml2)
	$(MAKE) -C $(builddir) install
