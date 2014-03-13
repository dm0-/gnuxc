xkeyboard-config        := xkeyboard-config-2.11
xkeyboard-config_url    := http://xorg.freedesktop.org/releases/individual/data/xkeyboard-config/$(xkeyboard-config).tar.bz2

configure-xkeyboard-config-rule:
	cd $(xkeyboard-config) && ./$(configure) \
		--disable-rpath \
		--enable-compat-rules \
		--enable-runtime-deps

build-xkeyboard-config-rule:
	$(MAKE) -C $(xkeyboard-config) all

install-xkeyboard-config-rule: $(call installed,xkbdata)
	test ! -d $(DESTDIR)/usr/share/X11/xkb/symbols/pc || $(RM) --recursive $(DESTDIR)/usr/share/X11/xkb/symbols/pc
	$(MAKE) -C $(xkeyboard-config) install
