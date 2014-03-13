grub                    := grub-2.02~beta2
grub_url                := http://alpha.gnu.org/gnu/grub/$(grub).tar.xz

ifeq ($(host),$(build))
export MKFONT := grub-mkfont --force-autohint
else
export MKFONT := grub2-mkfont --force-autohint
configure-grub-rule: PKG_CONFIG_LIBDIR = /usr/lib64/pkgconfig
endif

prepare-grub-rule:
	$(PATCH) -d $(grub) < $(patchdir)/$(grub)-hurd-relpath.patch
	$(COPY) $(patchdir)/$(grub)-sample.cfg $(grub)/sample.cfg
	$(COPY) $(patchdir)/$(grub)-starfield.cfg $(grub)/starfield.cfg

configure-grub-rule: CFLAGS := $(CFLAGS:-fstack-protector=)
configure-grub-rule:
	cd $(grub) && ./$(configure) \
		--libdir=/usr/lib \
		\
		--disable-rpath \
		--disable-werror \
		--enable-boot-time \
		--enable-cache-stats \
		--enable-grub-mkfont \
		--enable-grub-themes \
		--enable-liblzma \
		--enable-mm-debug \
		--without-included-regex

build-grub-rule:
	$(MAKE) -C $(grub) all

install-grub-rule: $(call installed,bash freetype xz)
	$(MAKE) -C $(grub) install

	$(INSTALL) -Dpm 644 $(grub)/sample.cfg $(DESTDIR)/boot/grub/sample.cfg
	$(INSTALL) -Dpm 644 $(grub)/sample.cfg $(DESTDIR)/boot/grub/grub.cfg
	$(SYMLINK) ../boot/grub/grub.cfg $(DESTDIR)/etc/grub.cfg

	$(INSTALL) -Dpm 644 $(grub)/starfield.cfg $(DESTDIR)/usr/share/grub/themes/starfield/theme.cfg
	$(SYMLINK) starfield $(DESTDIR)/usr/share/grub/themes/active
