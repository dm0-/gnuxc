xkeyboard-config        := xkeyboard-config-2.22
xkeyboard-config_key    := FFB4CCD275AAA422F5F9808E0661D98FC933A145
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
