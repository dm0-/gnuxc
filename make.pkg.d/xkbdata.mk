xkbdata                 := xkbdata-1.0.1
xkbdata_sha1            := 66ff0387bae7afc26444bdc564001d39c17e806a
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
