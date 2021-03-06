grub                    := grub-2.02
grub_key                := E53D497F3FA42AD8C9B4D1E835A93B74E82E4209
grub_url                := http://ftpmirror.gnu.org/grub/$(grub).tar.xz

ifeq ($(host),$(build))
export MKFONT := grub-mkfont --force-autohint
else
export MKFONT := grub2-mkfont --force-autohint
endif

$(call configure-rule,bios efi): private override export CFLAGS := $(CFLAGS:-fstack-protector%=)
$(call configure-rule,bios efi): private override configuration := --libdir=/usr/lib \
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

$(prepare-rule):
	$(call apply,smbios-module hurd-mkconfig)
# Regenerate everything for the new SMBIOS module.
	$(ECHO) ./grub-core/commands/smbios.c >> $(builddir)/po/POTFILES.in
	cd $(builddir) && $(PYTHON) gentpl.py Makefile.util.def Makefile.utilgcry.def > Makefile.util.am
	cd $(builddir)/grub-core && $(PYTHON) ../gentpl.py Makefile.core.def Makefile.gcry.def > Makefile.core.am
	$(RM) $(builddir)/configure

$(call configure-rule,bios): $(builddir)/configure
	$(MKDIR) $(builddir)/bios && cd $(builddir)/bios && ../$(configure) $(configuration)
$(call configure-rule,efi): $(builddir)/configure
	$(MKDIR) $(builddir)/efi && cd $(builddir)/efi && ../$(configure) $(configuration) \
		--with-platform=efi
	$(EDIT) 's, util/bash-completion.d,,g' $(builddir)/efi/Makefile

$(configure-rule): $(call configured,bios efi)

$(call build-rule,bios): $(call configured,bios)
	$(MAKE) -C $(builddir)/bios all
$(call build-rule,efi): $(call configured,efi)
	$(MAKE) -C $(builddir)/efi all

$(build-rule): $(call built,bios efi)

$(install-rule): $$(call installed,bash freetype xz)
	$(MAKE) -C $(builddir)/efi install
	$(MAKE) -C $(builddir)/bios install bashcompletiondir=/usr/share/bash-completion/completions
	$(INSTALL) -Dpm 0644 $(call addon-file,settings.sh) $(DESTDIR)/etc/default/grub
	$(INSTALL) -Dpm 0644 $(DESTDIR)/usr/share/locale/en{'@quot',}/LC_MESSAGES/grub.mo
	$(SYMLINK) ../boot/grub/grub.cfg $(DESTDIR)/etc/grub.cfg

# Write inline files.
$(call addon-file,settings.sh): | $$(@D)
	$(file >$@,$(contents))
$(prepared): $(call addon-file,settings.sh)


# Provide some default configuration settings for generating the boot menu.
override define contents
GRUB_DISABLE_SUBMENU=y
GRUB_TERMINAL_OUTPUT=gfxterm
GRUB_THEME=/boot/grub/themes/gnu/theme.txt
GRUB_TIMEOUT=60
endef
$(call addon-file,settings.sh): private override contents := $(value contents)
