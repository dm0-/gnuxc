theme                   := theme-1

ifneq ($(host),$(build))
prepare-theme-rule:
	$(COPY) $(patchdir)/$(theme)-theme.txt $(theme)/theme.txt
	$(COPY) $(patchdir)/$(theme)-theme.cfg $(theme)/theme.cfg
	$(DOWNLOAD) 'http://www.gnu.org/graphics/topbanner.png' > $(theme)/topbanner.png

$(theme)/FreeMono-%.pf2: $(call configured,theme)
	$(MKFONT) -o $@ -s $(*F) $(FREEFONTDIR)/FreeMono.[ot]tf
$(theme)/FreeSans-%.pf2: $(call configured,theme)
	$(MKFONT) -o $@ -s $(*F) $(FREEFONTDIR)/FreeSans.[ot]tf
$(theme)/FreeSans-Bold-%.pf2: $(call configured,theme)
	$(MKFONT) -o $@ -s $(*F) $(FREEFONTDIR)/FreeSansBold.[ot]tf
$(theme)/1bp.png24: $(call configured,theme)
	$(CONVERT) -size 1x1 'canvas:#000000' -strip $@
$(theme)/1mp.png24: $(call configured,theme)
	$(CONVERT) -size 1x1 'canvas:#900000' -strip $@
$(theme)/banner.png24: $(call configured,theme)
	$(CONVERT) $(theme)/topbanner.png -crop 550x100 -delete 1 -strip $@

build-theme-rule: \
		$(theme)/FreeMono-14.pf2 \
		$(theme)/FreeSans-12.pf2 \
		$(theme)/FreeSans-14.pf2 \
		$(theme)/FreeSans-16.pf2 \
		$(theme)/FreeSans-Bold-16.pf2 \
		$(theme)/1bp.png24 \
		$(theme)/1mp.png24 \
		$(theme)/banner.png24

install-theme-rule: $(call installed,grub)
	$(INSTALL) -Dpm 644 $(theme)/theme.txt $(DESTDIR)/usr/share/grub/themes/gnu/theme.txt
	$(INSTALL) -Dpm 644 $(theme)/theme.cfg $(DESTDIR)/usr/share/grub/themes/gnu/theme.cfg
	$(INSTALL) -Dpm 644 $(theme)/banner.png24 $(DESTDIR)/usr/share/grub/themes/gnu/banner.png

	$(INSTALL) -Dpm 644 $(theme)/1bp.png24 $(DESTDIR)/usr/share/grub/themes/gnu/1bp_e.png
	$(LINK) $(DESTDIR)/usr/share/grub/themes/gnu/1bp_{e,ne}.png
	$(LINK) $(DESTDIR)/usr/share/grub/themes/gnu/1bp_{e,n}.png
	$(LINK) $(DESTDIR)/usr/share/grub/themes/gnu/1bp_{e,nw}.png
	$(LINK) $(DESTDIR)/usr/share/grub/themes/gnu/1bp_{e,se}.png
	$(LINK) $(DESTDIR)/usr/share/grub/themes/gnu/1bp_{e,s}.png
	$(LINK) $(DESTDIR)/usr/share/grub/themes/gnu/1bp_{e,sw}.png
	$(LINK) $(DESTDIR)/usr/share/grub/themes/gnu/1bp_{e,w}.png

	$(INSTALL) -Dpm 644 $(theme)/1mp.png24 $(DESTDIR)/usr/share/grub/themes/gnu/1mp_c.png

	$(INSTALL) -Dpm 644 $(theme)/FreeMono-14.pf2 $(DESTDIR)/usr/share/grub/themes/gnu/FreeMono-14.pf2
	$(INSTALL) -Dpm 644 $(theme)/FreeSans-12.pf2 $(DESTDIR)/usr/share/grub/themes/gnu/FreeSans-12.pf2
	$(INSTALL) -Dpm 644 $(theme)/FreeSans-14.pf2 $(DESTDIR)/usr/share/grub/themes/gnu/FreeSans-14.pf2
	$(INSTALL) -Dpm 644 $(theme)/FreeSans-16.pf2 $(DESTDIR)/usr/share/grub/themes/gnu/FreeSans-16.pf2
	$(INSTALL) -Dpm 644 $(theme)/FreeSans-Bold-16.pf2 $(DESTDIR)/usr/share/grub/themes/gnu/FreeSans-Bold-16.pf2

	$(SYMLINK) gnu $(DESTDIR)/usr/share/grub/themes/active
endif
