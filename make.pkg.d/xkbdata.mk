xkbdata                 := xkbdata-1.0.1
xkbdata_url             := http://xorg.freedesktop.org/releases/individual/data/$(xkbdata).tar.bz2

$(configure-rule): configure := $(configure:--docdir%=)
$(configure-rule): configure := $(configure:--localedir%=)
$(configure-rule): configure := $(subst datarootdir,datadir,$(configure:--datadir%=))
$(configure-rule):
	cd $(builddir) && ./$(configure)

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,xorg-server)
	test ! -f $(DESTDIR)/usr/share/X11/xkb/symbols/pc || $(RM) $(DESTDIR)/usr/share/X11/xkb/symbols/pc
	$(MAKE) -C $(builddir) install
