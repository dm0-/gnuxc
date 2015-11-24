xz                      := xz-5.2.2
xz_url                  := http://tukaani.org/xz/$(xz).tar.xz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-rpath \
		--enable-debug \
		--enable-symbol-versions

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,coreutils)
	$(MAKE) -C $(builddir) install
