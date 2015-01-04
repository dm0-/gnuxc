theme                   := theme-1

prepare-theme-rule:
	$(DOWNLOAD) 'http://www.gnu.org/graphics/heckert_gnu.small.png' > $(theme)/logo.png
	$(DOWNLOAD) 'http://www.gnu.org/graphics/heckert_gnu.transparent.png' > $(theme)/icon.png
	$(DOWNLOAD) 'http://www.fsfla.org/ikiwiki/selibre/linux-libre/freedo.png' > $(theme)/logovm.png

ifneq ($(host),$(build))
# GNU GRUB theme
$(theme)/theme.txt: $(theme)/theme.txt.in
	$(SED) "s/@BUILD_DATE@/`date '+%Y-%m-%d'`/g" < $< > $@
$(theme)/theme.txt-vm: $(theme)/theme.txt
	$(SED) 's/^#VM#//' < $< > $@
$(theme)/FreeMono-%.pf2: $(call configured,theme)
	$(MKFONT) -o $@ -s $(*F) $(FREEFONTDIR)/FreeMono.[ot]tf
$(theme)/FreeSans-%.pf2: $(call configured,theme)
	$(MKFONT) -o $@ -s $(*F) $(FREEFONTDIR)/FreeSans.[ot]tf
$(theme)/FreeSans-Bold-%.pf2: $(call configured,theme)
	$(MKFONT) -o $@ -s $(*F) $(FREEFONTDIR)/FreeSansBold.[ot]tf
$(theme)/content.png24: $(call configured,theme)
	$(CONVERT) -size 1x1 'canvas:#FFFFFF' -strip $@
$(theme)/label.png24: $(call configured,theme)
	$(CONVERT) -size 1x1 'canvas:#C9CCCF' -strip $@
$(theme)/selected.png24: $(call configured,theme)
	$(CONVERT) -size 1x1 'canvas:#900000' -strip $@
$(theme)/shadow_left.png24: $(call configured,theme)
	$(CONVERT) -size 1x20 'gradient:#E7E9EB-#B9BCBF' -rotate 270 -strip $@
$(theme)/shadow_right.png24: $(call configured,theme)
	$(CONVERT) -size 1x20 'gradient:#E7E9EB-#B9BCBF' -rotate 90 -strip $@
$(theme)/logo.png24: $(call configured,theme)
	$(CONVERT) $(theme)/logo.png -crop 140x140+2+0 -scale 80x80 -strip $@
$(theme)/logovm.png24: $(call configured,theme)
	$(CONVERT) $(theme)/logovm.png -gravity Center -trim -extent 220x220 -scale 80x80 -strip $@

# Apple EFI theme
$(theme)/label.gray: $(call configured,theme)
# Mimic the margins and opacity of Fedora's disk label.
	$(CONVERT) -background '#FFFFFF' -bordercolor '#FFFFFF' -colorspace Gray -depth 8 -fill '#000000' -font FreeSans -gravity Center -pointsize 9 \
		label:GNU -extent x12 -fill '#FEFEFE' -draw 'point 9,0' -draw 'point 9,11' -trim -brightness-contrast -15x50 -border 7x -strip $@
$(theme)/label2x.gray: $(call configured,theme)
	$(CONVERT) -background '#FFFFFF' -bordercolor '#FFFFFF' -colorspace Gray -depth 8 -fill '#000000' -font FreeSans -gravity Center -pointsize 22 \
		label:GNU -extent x24 -fill '#FEFEFE' -draw 'point 9,0' -draw 'point 9,23' -trim -border 2x -strip $@
$(theme)/%.vol: $(theme)/%.gray
	$(BASH) $(theme)/gray2vol.sh $< > $@
$(theme)/icon_opaque.png: $(call configured,theme)
	$(CONVERT) $(theme)/icon.png -fill '#FFFFFF' +opaque '#000000' -draw 'line 0,0 0,500' -monochrome -strip $@
$(theme)/icon.png32: $(theme)/icon_opaque.png
	$(CONVERT) $< -background none -fill none -draw 'color 0,0 floodfill' -draw 'image SrcOver 0,0 535,523 $(theme)/icon.png' -gravity Center -extent 535x535 -strip $@
$(theme)/icon-%.png32: $(theme)/icon.png32
	$(CONVERT) $< -scale $(*F)x$(*F) -strip $@
$(theme)/icon.icns: $(theme)/icon-512.png32 $(theme)/icon-256.png32 $(theme)/icon-128.png32
	png2icns $@ $^

build-theme-rule: $(theme)/icon.icns $(theme)/label.vol $(theme)/label2x.vol \
		$(theme)/theme.txt $(theme)/theme.txt-vm \
		$(theme)/FreeMono-14.pf2 $(theme)/FreeSans-12.pf2 $(theme)/FreeSans-14.pf2 $(theme)/FreeSans-16.pf2 \
		$(theme)/FreeSans-Bold-16.pf2 $(theme)/FreeSans-Bold-30.pf2 $(theme)/FreeSans-Bold-40.pf2 \
		$(theme)/content.png24 $(theme)/label.png24 $(theme)/selected.png24 \
		$(theme)/logo.png24 $(theme)/logovm.png24 $(theme)/shadow_left.png24 $(theme)/shadow_right.png24

install-theme-rule: $(call installed,grub)
	$(INSTALL) -Dpm 644 $(theme)/icon.icns $(DESTDIR)/usr/share/themes/gnu/efi/volume.icns
	$(INSTALL) -Dpm 644 $(theme)/label.vol $(DESTDIR)/usr/share/themes/gnu/efi/label.vol
	$(INSTALL) -Dpm 644 $(theme)/label2x.vol $(DESTDIR)/usr/share/themes/gnu/efi/label2x.vol

	$(INSTALL) -Dpm 644 $(theme)/theme.txt $(DESTDIR)/usr/share/themes/gnu/grub/theme.txt
	$(INSTALL) -Dpm 644 $(theme)/theme.txt-vm $(DESTDIR)/usr/share/themes/gnu/grub/theme.txt-vm
	$(INSTALL) -Dpm 644 $(theme)/logo.png24 $(DESTDIR)/usr/share/themes/gnu/grub/logo.png
	$(INSTALL) -Dpm 644 $(theme)/logovm.png24 $(DESTDIR)/usr/share/themes/gnu/grub/logovm.png
	$(INSTALL) -Dpm 644 $(theme)/content.png24 $(DESTDIR)/usr/share/themes/gnu/grub/content.png
	$(INSTALL) -Dpm 644 $(theme)/label.png24 $(DESTDIR)/usr/share/themes/gnu/grub/label.png
	$(INSTALL) -Dpm 644 $(theme)/selected.png24 $(DESTDIR)/usr/share/themes/gnu/grub/selected_c.png
	$(INSTALL) -Dpm 644 $(theme)/shadow_left.png24 $(DESTDIR)/usr/share/themes/gnu/grub/shadow_left.png
	$(INSTALL) -Dpm 644 $(theme)/shadow_right.png24 $(DESTDIR)/usr/share/themes/gnu/grub/shadow_right.png
	$(INSTALL) -Dpm 644 $(theme)/FreeMono-14.pf2 $(DESTDIR)/usr/share/themes/gnu/grub/FreeMono-14.pf2
	$(INSTALL) -Dpm 644 $(theme)/FreeSans-12.pf2 $(DESTDIR)/usr/share/themes/gnu/grub/FreeSans-12.pf2
	$(INSTALL) -Dpm 644 $(theme)/FreeSans-14.pf2 $(DESTDIR)/usr/share/themes/gnu/grub/FreeSans-14.pf2
	$(INSTALL) -Dpm 644 $(theme)/FreeSans-16.pf2 $(DESTDIR)/usr/share/themes/gnu/grub/FreeSans-16.pf2
	$(INSTALL) -Dpm 644 $(theme)/FreeSans-Bold-16.pf2 $(DESTDIR)/usr/share/themes/gnu/grub/FreeSans-Bold-16.pf2
	$(INSTALL) -Dpm 644 $(theme)/FreeSans-Bold-30.pf2 $(DESTDIR)/usr/share/themes/gnu/grub/FreeSans-Bold-30.pf2
	$(INSTALL) -Dpm 644 $(theme)/FreeSans-Bold-40.pf2 $(DESTDIR)/usr/share/themes/gnu/grub/FreeSans-Bold-40.pf2

# Install the theme files in the "active" locations.
	$(SYMLINK) ../../themes/gnu/grub $(DESTDIR)/usr/share/grub/themes/gnu
# The EFI directory needs its own copies since it's a different file system.
	$(INSTALL) -Dpm 644 $(theme)/icon.icns $(DESTDIR)/boot/efi/.VolumeIcon.icns
	$(INSTALL) -Dpm 644 $(theme)/label.vol $(DESTDIR)/boot/efi/System/Library/CoreServices/.disk_label
	$(INSTALL) -Dpm 644 $(theme)/label2x.vol $(DESTDIR)/boot/efi/System/Library/CoreServices/.disk_label_2x
endif

# Provide a GRUB theme definition file.
$(theme)/theme.txt.in: $(patchdir)/$(theme)-theme.txt | $(theme)
	$(COPY) $< $@
$(call prepared,theme): $(theme)/theme.txt.in

# Provide a script to convert gray pixels to the Apple firmware label format.
$(theme)/gray2vol.sh: $(patchdir)/$(theme)-gray2vol.sh | $(theme)
	$(COPY) $< $@
$(call prepared,theme): $(theme)/gray2vol.sh
