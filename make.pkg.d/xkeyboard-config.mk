xkeyboard-config        := xkeyboard-config-2.18
xkeyboard-config_sha1   := d41335ec37b363ddaf2f0dcb121436dfc627ced5
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
