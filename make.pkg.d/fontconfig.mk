fontconfig              := fontconfig-2.11.0
fontconfig_url          := http://www.freedesktop.org/software/fontconfig/release/$(fontconfig).tar.bz2

configure-fontconfig-rule:
	cd $(fontconfig) && ./$(configure) \
		--disable-silent-rules \
		--enable-iconv \
		--enable-libxml2

build-fontconfig-rule:
	$(MAKE) -C $(fontconfig) all \
		CPPFLAGS=-DPATH_MAX=4096

install-fontconfig-rule: $(call installed,freetype libxml2)
	$(MAKE) -C $(fontconfig) install
