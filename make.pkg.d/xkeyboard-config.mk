xkeyboard-config        := xkeyboard-config-2.16
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
