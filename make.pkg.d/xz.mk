xz                      := xz-5.2.2
xz_sha1                 := 72c567d3263345844191a7e618779b179d1f49e0
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
