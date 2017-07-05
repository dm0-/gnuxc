xz                      := xz-5.2.3
xz_sha1                 := a2975d12e0905daec48ec87c0098602e0669d195
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
