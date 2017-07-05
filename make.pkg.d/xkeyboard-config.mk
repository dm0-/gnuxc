xkeyboard-config        := xkeyboard-config-2.21
xkeyboard-config_sha1   := ccdc53ad0ff6bbabda19ef30a47c2cbe014d42ec
xkeyboard-config_url    := http://xorg.freedesktop.org/releases/individual/data/xkeyboard-config/$(xkeyboard-config).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-rpath \
		--enable-compat-rules \
		--enable-runtime-deps

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,xkbdata)
	test ! -d $(DESTDIR)/usr/share/X11/xkb/symbols/pc || $(RM) --recursive $(DESTDIR)/usr/share/X11/xkb/symbols/pc
	$(MAKE) -C $(builddir) install
