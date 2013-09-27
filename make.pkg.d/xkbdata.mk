xkbdata                 := xkbdata-1.0.1
xkbdata_url             := http://xorg.freedesktop.org/releases/individual/data/$(xkbdata).tar.bz2

configure-xkbdata-rule: configure := $(configure:--docdir%=)
configure-xkbdata-rule: configure := $(configure:--localedir%=)
configure-xkbdata-rule: configure := $(subst datarootdir,datadir,$(configure:--datadir%=))
configure-xkbdata-rule:
	cd $(xkbdata) && ./$(configure)

build-xkbdata-rule:
	$(MAKE) -C $(xkbdata) all

install-xkbdata-rule: $(call installed,xorg-server)
	test ! -f $(DESTDIR)/usr/share/X11/xkb/symbols/pc || $(RM) $(DESTDIR)/usr/share/X11/xkb/symbols/pc
	$(MAKE) -C $(xkbdata) install
