theme                   := theme-1

$(builddir)/logo.png: | $$(@D)
	$(DOWNLOAD) 'http://www.gnu.org/graphics/heckert_gnu.small.png' > $@
$(builddir)/icon.png: | $$(@D)
	$(DOWNLOAD) 'http://www.gnu.org/graphics/heckert_gnu.transparent.png' > $@
$(builddir)/logovm.png: | $$(@D)
	$(DOWNLOAD) 'http://www.fsfla.org/ikiwiki/selibre/linux-libre/freedo.png' > $@
$(prepared): $(builddir)/icon.png $(builddir)/logo.png $(builddir)/logovm.png

$(builddir)/theme.txt: $(call addon-file,theme.txt.in)
	$(SED) "s/@BUILD_DATE@/`date '+%Y-%m-%d'`/g" < $< > $@
$(builddir)/theme.txt-vm: $(builddir)/theme.txt
	$(SED) 's/^#VM#//' < $< > $@
$(builddir)/FreeMono-%.pf2: | $$(@D)
	$(MKFONT) -o $@ -s $(*F) $(FREEFONTDIR)/FreeMono.[ot]tf
$(builddir)/FreeSans-%.pf2: | $$(@D)
	$(MKFONT) -o $@ -s $(*F) $(FREEFONTDIR)/FreeSans.[ot]tf
$(builddir)/FreeSans-Bold-%.pf2: | $$(@D)
	$(MKFONT) -o $@ -s $(*F) $(FREEFONTDIR)/FreeSansBold.[ot]tf
$(built): $(builddir)/theme.txt-vm \
	$(builddir)/FreeMono-14.pf2 $(builddir)/FreeSans-12.pf2 $(builddir)/FreeSans-14.pf2 $(builddir)/FreeSans-16.pf2 \
	$(builddir)/FreeSans-Bold-16.pf2 $(builddir)/FreeSans-Bold-30.pf2 $(builddir)/FreeSans-Bold-40.pf2

ifneq ($(host),$(build))
# GRUB theme images
$(builddir)/content.png24: | $$(@D)
	$(CONVERT) -size 1x1 'canvas:#FFFFFF' -strip $@
$(builddir)/label.png24: | $$(@D)
	$(CONVERT) -size 1x1 'canvas:#C9CCCF' -strip $@
$(builddir)/selected.png24: | $$(@D)
	$(CONVERT) -size 1x1 'canvas:#900000' -strip $@
$(builddir)/shadow_left.png24: | $$(@D)
	$(CONVERT) -size 1x20 'gradient:#E7E9EB-#B9BCBF' -rotate 270 -strip $@
$(builddir)/shadow_right.png24: | $$(@D)
	$(CONVERT) -size 1x20 'gradient:#E7E9EB-#B9BCBF' -rotate 90 -strip $@
$(builddir)/logo.png24: $(builddir)/logo.png
	$(CONVERT) $< -crop 140x140+2+0 -scale 80x80 -strip $@
$(builddir)/logovm.png24: $(builddir)/logovm.png
	$(CONVERT) $< -gravity Center -trim -extent 220x220 -scale 80x80 -strip $@
$(built): $(builddir)/content.png24 $(builddir)/label.png24 $(builddir)/selected.png24 \
	$(builddir)/shadow_left.png24 $(builddir)/shadow_right.png24 $(builddir)/logo.png24 $(builddir)/logovm.png24

# Apple EFI theme images
$(builddir)/label.gray: | $$(@D)
	$(CONVERT) -background '#FFFFFF' -bordercolor '#FFFFFF' -colorspace Gray -depth 8 -fill '#000000' -font FreeSans -gravity Center -pointsize 9 \
		label:GNU -extent x12 -fill '#FEFEFE' -draw 'point 9,0' -draw 'point 9,11' -trim -brightness-contrast -15x50 -border 7x -strip $@
$(builddir)/label2x.gray: | $$(@D)
	$(CONVERT) -background '#FFFFFF' -bordercolor '#FFFFFF' -colorspace Gray -depth 8 -fill '#000000' -font FreeSans -gravity Center -pointsize 22 \
		label:GNU -extent x24 -fill '#FEFEFE' -draw 'point 9,0' -draw 'point 9,23' -trim -border 2x -strip $@
$(builddir)/%.vol: $(builddir)/%.gray $(call addon-file,gray2vol.sh)
	$(BASH) $(call addon-file,gray2vol.sh) $< > $@
$(builddir)/icon_opaque.png: $(builddir)/icon.png
	$(CONVERT) $< -fill '#FFFFFF' -draw 'line 0,0 0,500' +opaque '#000000' -monochrome -strip $@
$(builddir)/icon.png32: $(builddir)/icon_opaque.png
	$(CONVERT) $< -background none -fill none -draw 'color 0,0 floodfill' -draw 'image SrcOver 0,0 535,523 $(builddir)/icon.png' -gravity Center -extent 535x535 -strip $@
$(builddir)/icon-%.png32: $(builddir)/icon.png32
	$(CONVERT) $< -scale $(*F)x$(*F) -strip $@
$(builddir)/icon.icns: $(builddir)/icon-512.png32 $(builddir)/icon-256.png32 $(builddir)/icon-128.png32
	png2icns $@ $^
$(built): $(builddir)/icon.icns $(builddir)/label.vol $(builddir)/label2x.vol

# XDM theme images
$(builddir)/login-logo.xpm: $(builddir)/icon-256.png32
#	$(CONVERT) -size 535x535 'gradient:#FAFAFA-#6C6C6C' -draw 'image SrcOver 0,0 535,535 $<' -gravity Center -scale 256x256 -strip $@
	$(CONVERT) $< -strip $@
$(builddir)/login-logo-bw.xpm: $(builddir)/icon-256.png32
	$(CONVERT) -size 256x256 'canvas:white' -draw 'image SrcOver 0,0 256x256 $<' -depth 8 -strip $@
$(built): $(builddir)/login-logo.xpm $(builddir)/login-logo-bw.xpm

$(install-rule):
	$(INSTALL) -Dpm 644 $(builddir)/icon.icns $(DESTDIR)/usr/share/themes/gnu/efi/volume.icns
	$(INSTALL) -Dpm 644 $(builddir)/label.vol $(DESTDIR)/usr/share/themes/gnu/efi/label.vol
	$(INSTALL) -Dpm 644 $(builddir)/label2x.vol $(DESTDIR)/usr/share/themes/gnu/efi/label2x.vol

	$(INSTALL) -Dpm 644 $(builddir)/theme.txt $(DESTDIR)/usr/share/themes/gnu/grub/theme.txt
	$(INSTALL) -Dpm 644 $(builddir)/theme.txt-vm $(DESTDIR)/usr/share/themes/gnu/grub/theme.txt-vm
	$(INSTALL) -Dpm 644 $(builddir)/logo.png24 $(DESTDIR)/usr/share/themes/gnu/grub/logo.png
	$(INSTALL) -Dpm 644 $(builddir)/logovm.png24 $(DESTDIR)/usr/share/themes/gnu/grub/logovm.png
	$(INSTALL) -Dpm 644 $(builddir)/content.png24 $(DESTDIR)/usr/share/themes/gnu/grub/content.png
	$(INSTALL) -Dpm 644 $(builddir)/label.png24 $(DESTDIR)/usr/share/themes/gnu/grub/label.png
	$(INSTALL) -Dpm 644 $(builddir)/selected.png24 $(DESTDIR)/usr/share/themes/gnu/grub/selected_c.png
	$(INSTALL) -Dpm 644 $(builddir)/shadow_left.png24 $(DESTDIR)/usr/share/themes/gnu/grub/shadow_left.png
	$(INSTALL) -Dpm 644 $(builddir)/shadow_right.png24 $(DESTDIR)/usr/share/themes/gnu/grub/shadow_right.png
	$(INSTALL) -Dpm 644 $(builddir)/FreeMono-14.pf2 $(DESTDIR)/usr/share/themes/gnu/grub/FreeMono-14.pf2
	$(INSTALL) -Dpm 644 $(builddir)/FreeSans-12.pf2 $(DESTDIR)/usr/share/themes/gnu/grub/FreeSans-12.pf2
	$(INSTALL) -Dpm 644 $(builddir)/FreeSans-14.pf2 $(DESTDIR)/usr/share/themes/gnu/grub/FreeSans-14.pf2
	$(INSTALL) -Dpm 644 $(builddir)/FreeSans-16.pf2 $(DESTDIR)/usr/share/themes/gnu/grub/FreeSans-16.pf2
	$(INSTALL) -Dpm 644 $(builddir)/FreeSans-Bold-16.pf2 $(DESTDIR)/usr/share/themes/gnu/grub/FreeSans-Bold-16.pf2
	$(INSTALL) -Dpm 644 $(builddir)/FreeSans-Bold-30.pf2 $(DESTDIR)/usr/share/themes/gnu/grub/FreeSans-Bold-30.pf2
	$(INSTALL) -Dpm 644 $(builddir)/FreeSans-Bold-40.pf2 $(DESTDIR)/usr/share/themes/gnu/grub/FreeSans-Bold-40.pf2

	$(INSTALL) -Dpm 644 $(builddir)/login-logo.xpm $(DESTDIR)/usr/share/themes/gnu/xdm/login-logo.xpm
	$(INSTALL) -Dpm 644 $(builddir)/login-logo-bw.xpm $(DESTDIR)/usr/share/themes/gnu/xdm/login-logo-bw.xpm

# Install the theme files in the "active" locations.
	$(INSTALL) -dm 755 $(DESTDIR)/usr/share/grub/themes
	$(SYMLINK) ../../themes/gnu/grub $(DESTDIR)/usr/share/grub/themes/gnu
	$(INSTALL) -dm 755 $(DESTDIR)/usr/share/pixmaps
	$(SYMLINK) ../themes/gnu/xdm/login-logo.xpm $(DESTDIR)/usr/share/pixmaps/
	$(SYMLINK) ../themes/gnu/xdm/login-logo-bw.xpm $(DESTDIR)/usr/share/pixmaps/
# The EFI directory needs its own copies since it's a different file system.
	$(INSTALL) -dm 755 $(DESTDIR)/boot/efi/System/Library/CoreServices
	$(INSTALL) -Dpm 644 $(builddir)/icon.icns $(DESTDIR)/boot/efi/.VolumeIcon.icns
	$(INSTALL) -Dpm 644 $(builddir)/label.vol $(DESTDIR)/boot/efi/System/Library/CoreServices/.disk_label
	$(INSTALL) -Dpm 644 $(builddir)/label2x.vol $(DESTDIR)/boot/efi/System/Library/CoreServices/.disk_label_2x
endif

# Write inline files.
$(call addon-file,gray2vol.sh): | $$(@D)
	$(file >$@,$(contents))
$(prepared): $(call addon-file,gray2vol.sh)

# Provide a GRUB theme definition file.
$(call addon-file,theme.txt.in): $(patchdir)/$(theme)-theme.txt | $$(@D)
	$(COPY) $< $@
$(prepared): $(call addon-file,theme.txt.in)


# Provide a script to convert gray pixels to the Apple firmware label format.
override define contents
#!/bin/bash -e
# Generate the image with: convert -colorspace Gray -depth 8 [...] image.gray
export LANG=C

# Verify we were given a non-empty readable file.
image=${1?Usage: $0 /path/to/image.gray}
test -f "$image" -a -r "$image" -a -s "$image" || exit 1

# Check if it's a "2x" image and double the rows.
test "${image/2x/}" = "$image" && c=0c || c=18

# Verify the image has (could have?) 12/24 rows.
declare -i size=$(stat -c '%s' "$image")
! (( size % 0x$c )) || exit 2

# Verify the number of columns can fit in two bytes.
declare -i w=$(( size / 0x$c ))
(( w <= 0xFFFF )) || exit 3

# Write the image header.
echo -en '\x01\x'$(printf '%02x\\x%02x' $(( w >> 8 )) $(( w % 256 )))'\x00\x'$c

# Map the 8-bit depth grayscale pixels to the Mac palette.
declare -ar gray=( d6 ff fe ab fd fc 80 fb fa 55 f9 f8 2a f7 f6 00 )
while IFS= read -rsN1 pixel
do
        echo -en '\x'${gray[$(( $(printf '%u' "'$pixel") >> 4 ))]}
done < <(tr '\0' $'\x01' < "$image") # (read can't handle null bytes)
endef
$(call addon-file,gray2vol.sh): private override contents := $(value contents)
