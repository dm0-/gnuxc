grub                    := grub-2.00+20130519
grub_url                := http://alpha.gnu.org/gnu/grub/$(grub).tar.xz

ifeq ($(host),$(build))
export MKFONT := grub-mkfont --force-autohint
else
export MKFONT := grub2-mkfont --force-autohint
endif

prepare-grub-rule:
	$(COPY) $(patchdir)/$(grub)-sample.cfg $(grub)/sample.cfg
	$(COPY) $(patchdir)/$(grub)-starfield.cfg $(grub)/starfield.cfg
	$(PATCH) -d $(grub) < $(patchdir)/$(grub)-cross-freetype.patch
	$(PATCH) -d $(grub) < $(patchdir)/$(grub)-cross-theme.patch
	$(RM) $(grub)/configure

configure-grub-rule: CFLAGS := $(CFLAGS:-fstack-protector=)
configure-grub-rule:
	cd $(grub) && ./$(configure) \
		--disable-rpath \
		--disable-werror \
		--enable-boot-time \
		--enable-cache-stats \
		--enable-grub-mkfont \
		--enable-mm-debug \
		--without-included-regex

ifeq ($(host),$(build))
build-grub-rule: MKFONT := $(CURDIR)/$(grub)/$(MKFONT)
endif
build-grub-rule:
	$(MAKE) -C $(grub) all

install-grub-rule: $(call installed,bash freetype)
	$(MAKE) -C $(grub) install

	$(INSTALL) -Dpm 644 $(grub)/sample.cfg $(DESTDIR)/boot/grub/sample.cfg
	$(INSTALL) -Dpm 644 $(grub)/sample.cfg $(DESTDIR)/boot/grub/grub.cfg
	$(SYMLINK) ../boot/grub/grub.cfg $(DESTDIR)/etc/grub.cfg

	$(INSTALL) -Dpm 644 $(grub)/starfield.cfg $(DESTDIR)/usr/share/grub/themes/starfield/theme.cfg
	$(SYMLINK) starfield $(DESTDIR)/usr/share/grub/themes/active
