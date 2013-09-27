xbill                   := xbill-2.1
xbill_url               := http://www.xbill.org/download/$(xbill).tar.gz

prepare-xbill-rule:
	$(RM) $(xbill)/configure

configure-xbill-rule:
	cd $(xbill) && ./$(configure) \
		--localstatedir=/var/games \
		\
		--enable-athena \
		--with-x \
		\
		--disable-gtk \
		--disable-motif

build-xbill-rule:
	$(MAKE) -C $(xbill) all
	$(CONVERT) $(xbill)/pixmaps/icon.xpm -trim -fill '#FFFFFF00' -draw 'color 0,0 floodfill color 48,0 floodfill color 0,48 floodfill color 48,48 floodfill' +repage -crop 48x48+1+1 +repage -strip $(xbill)/xbill.xpm

install-xbill-rule: $(call installed,libXaw)
	$(MAKE) -C $(xbill) install
	$(INSTALL) -Dpm 644 $(xbill)/xbill.xpm $(DESTDIR)/usr/share/pixmaps/xbill.xpm
