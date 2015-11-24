xbill                   := xbill-2.1
xbill_url               := http://www.xbill.org/download/$(xbill).tar.gz

$(prepare-rule):
	$(RM) $(builddir)/configure

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--localstatedir=/var/games \
		\
		--enable-athena \
		--with-x \
		\
		--disable-gtk \
		--disable-motif

$(build-rule):
	$(MAKE) -C $(builddir) all
	$(CONVERT) $(builddir)/pixmaps/icon.xpm -trim -fill '#FFFFFF00' -draw 'color 0,0 floodfill color 48,0 floodfill color 0,48 floodfill color 48,48 floodfill' +repage -crop 48x48+1+1 +repage -strip $(builddir)/xbill.xpm

$(install-rule): $$(call installed,libXaw)
	$(MAKE) -C $(builddir) install
	$(INSTALL) -Dpm 644 $(builddir)/xbill.xpm $(DESTDIR)/usr/share/pixmaps/xbill.xpm
