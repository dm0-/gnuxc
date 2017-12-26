xbill                   := xbill-2.1
xbill_sha1              := ca466fb90a7c41055005d2e4dcece2e82b6c55c6
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
	$(CONVERT) $(builddir)/pixmaps/icon.xpm -trim -fill '#FFFFFF00' -draw 'color 0,0 floodfill color 48,0 floodfill color 0,48 floodfill color 48,48 floodfill' +repage -crop 48x48+1+1 +repage -strip $(builddir)/xbill.png32

$(install-rule): $$(call installed,libXaw)
	$(MAKE) -C $(builddir) install
	$(INSTALL) -Dpm 0644 $(builddir)/xbill.png32 $(DESTDIR)/usr/share/icons/hicolor/48x48/apps/xbill.png
