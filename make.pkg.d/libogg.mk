libogg                  := libogg-1.3.2
libogg_sha1             := 5e525ec6a4135066932935c01d2c309ea5009f8d
libogg_url              := http://downloads.xiph.org/releases/ogg/$(libogg).tar.xz

$(configure-rule):
	cd $(builddir) && ./$(configure)

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,glibc)
	$(MAKE) -C $(builddir) install
