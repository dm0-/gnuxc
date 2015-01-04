grub                    := grub-2.02~beta2
grub_url                := http://alpha.gnu.org/gnu/grub/$(grub).tar.xz

ifeq ($(host),$(build))
export MKFONT := grub-mkfont --force-autohint
else
export MKFONT := grub2-mkfont --force-autohint
endif

grub_configuration := --libdir=/usr/lib \
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

prepare-grub-rule:
	$(PATCH) -d $(grub) < $(patchdir)/$(grub)-hurd-mkconfig.patch
# Integrate the SMBIOS module into the build.
	$(ECHO) -e '\nmodule = {\n  name = smbios;\n  x86 = commands/i386/smbios.c;\n  enable = x86;\n};' >> $(grub)/grub-core/Makefile.core.def
	$(ECHO) ./grub-core/commands/i386/smbios.c >> $(grub)/po/POTFILES.in
	$(RM) $(grub)/configure

configure-grub-bios-rule: $(grub)/configure
	$(MKDIR) $(grub)/bios && cd $(grub)/bios && ../$(configure) $(grub_configuration)
configure-grub-efi-rule: $(grub)/configure
	$(MKDIR) $(grub)/efi && cd $(grub)/efi && ../$(configure) $(grub_configuration) \
		--with-platform=efi
	$(EDIT) 's, util/bash-completion.d,,g' $(grub)/efi/Makefile

configure-grub-rule: CFLAGS := $(CFLAGS:-fstack-protector%=)
configure-grub-rule: $(call configured,grub-bios grub-efi)

build-grub-bios-rule: $(call configured,grub)
	$(MAKE) -C $(grub)/bios all
build-grub-efi-rule: $(call configured,grub)
	$(MAKE) -C $(grub)/efi all

build-grub-rule: $(call built,grub-bios grub-efi)

install-grub-rule: $(call installed,bash freetype xz)
	$(MAKE) -C $(grub)/efi install
	$(MAKE) -C $(grub)/bios install bashcompletiondir=/usr/share/bash-completion/completions
	$(INSTALL) -Dpm 644 $(grub)/settings.sh $(DESTDIR)/etc/default/grub
	$(INSTALL) -Dpm 644 $(DESTDIR)/usr/share/locale/en{'@quot',}/LC_MESSAGES/grub.mo
	$(SYMLINK) ../boot/grub/grub.cfg $(DESTDIR)/etc/grub.cfg

clean-grub-variants:
	$(RM) $(timedir)/{build,configure}-grub-{bios,efi}-{rule,stamp}
.PHONY clean-grub: clean-grub-variants

# Provide some default configuration settings for generating the boot menu.
$(grub)/settings.sh: | $(grub)
	$(ECHO) GRUB_DISABLE_SUBMENU=y > $@
	$(ECHO) GRUB_TERMINAL_OUTPUT=gfxterm >> $@
	$(ECHO) GRUB_THEME=/boot/grub/themes/gnu/theme.txt >> $@
	$(ECHO) GRUB_TIMEOUT=60 >> $@
$(call prepared,grub): $(grub)/settings.sh

# Provide a module "smbios" to give GRUB scripts access to system information.
$(grub)/grub-core/commands/i386/smbios.c: $(patchdir)/$(grub)-smbios.c | $(grub)
	$(COPY) $< $@
$(call prepared,grub): $(grub)/grub-core/commands/i386/smbios.c
