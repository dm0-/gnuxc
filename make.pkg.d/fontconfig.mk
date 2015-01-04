fontconfig              := fontconfig-2.11.91
fontconfig_url          := http://www.freedesktop.org/software/fontconfig/release/$(fontconfig).tar.bz2

configure-fontconfig-rule:
	cd $(fontconfig) && ./$(configure) \
		--disable-silent-rules \
		--enable-iconv \
		--enable-libxml2 \
		--enable-static \
		CPPFLAGS=-DPATH_MAX=4096
ifneq ($(host),$(build))
	$(EDIT) 's,$(sysroot),,g' $(fontconfig)/fontconfig.pc
endif

build-fontconfig-rule:
	$(MAKE) -C $(fontconfig) all

install-fontconfig-rule: $(call installed,freetype libxml2)
	$(MAKE) -C $(fontconfig) install
