hal                     := hal-1

hal-busybox             := $(hal)/busybox-1.23.0
hal-busybox_url         := http://www.busybox.net/downloads/$(hal-busybox:$(hal)/%=%).tar.bz2

hal-linux-libre         := $(hal)/linux-libre-3.18.1
hal-linux-libre_branch  := $(hal-linux-libre:$(hal)/linux-libre-%=linux-%)
hal-linux-libre_url     := http://linux-libre.fsfla.org/pub/linux-libre/releases/$(hal-linux-libre_branch:linux-%=%)-gnu/$(hal-linux-libre:$(hal)/%=%)-gnu.tar.xz

hal-qemu                := $(hal)/qemu-1.7.2
hal-qemu_branch         := $(hal-qemu:$(hal)/qemu-%=v%)
hal-qemu_url            := git://git.qemu.org/qemu.git

ifneq ($(host),$(build))
prepare-hal-rule: $(call prepared,hal-busybox hal-linux-libre hal-qemu)
#	t=../../../EFI/gnu/hal-vmlinuz.efi ; printf 'XSym\n%04u\n%.32s\n%-1024s' $${#t} "`echo -n $$t | md5sum`" $$t$$'\n' > $(hal)/link.efi

configure-hal-rule: $(call configured,hal-busybox hal-linux-libre hal-qemu)

build-hal-rule: $(call built,hal-busybox hal-linux-libre hal-qemu)
	$(MKDIR) $(hal)/root/{bin,dev,etc,proc,sbin,sys,usr/share/qemu}
	$(INSTALL) -Dpm 755 $(hal)/init.sh $(hal)/root/init
	$(INSTALL) -Dpm 644 $(hal)/emacs2.kbd $(hal)/root/usr/share/kbd/emacs2
	$(INSTALL) -Dpm 644 $(hal)/linux.terminfo $(hal)/root/usr/share/terminfo/l/linux
	$(INSTALL) -Dpm 755 $(hal)/udhcpc.sh $(hal)/root/usr/share/udhcpc/default.script
# Install BusyBox.
	$(INSTALL) -pm 755 -st $(hal)/root/sbin $(hal-busybox)/busybox
	$(SYMLINK) ../sbin/busybox $(hal)/root/bin/ash
	$(SYMLINK) ../sbin/busybox $(hal)/root/bin/find
	$(SYMLINK) ../sbin/busybox $(hal)/root/bin/free
	$(SYMLINK) ../sbin/busybox $(hal)/root/bin/loadkmap
	$(SYMLINK) ../sbin/busybox $(hal)/root/bin/mount
	$(SYMLINK) ../sbin/busybox $(hal)/root/bin/sleep
	$(SYMLINK) busybox $(hal)/root/sbin/findfs
	$(SYMLINK) busybox $(hal)/root/sbin/ifconfig
	$(SYMLINK) busybox $(hal)/root/sbin/mdev
	$(SYMLINK) busybox $(hal)/root/sbin/poweroff
	$(SYMLINK) busybox $(hal)/root/sbin/reboot
	$(SYMLINK) busybox $(hal)/root/sbin/route
	$(SYMLINK) busybox $(hal)/root/sbin/udhcpc
# Install QEMU.
	$(INSTALL) -pm 755 -st $(hal)/root/bin \
		$(hal-qemu)/x86_64-softmmu/qemu-system-x86_64
	$(INSTALL) -pm 644 -t $(hal)/root/usr/share/qemu \
		$(hal-qemu)/pc-bios/bios.bin \
		$(hal-qemu)/pc-bios/efi-rtl8139.rom \
		$(hal-qemu)/pc-bios/kvmvapic.bin \
		$(hal-qemu)/pc-bios/vgabios-stdvga.bin
# Finalize.
	$(LINK) $(hal-linux-libre)/arch/x86/boot/bzImage $(hal)/vmlinuz
	(cd $(hal)/root && find * | cpio -co) | gzip -9 > $(hal)/initrd.img

install-hal-rule:
	$(INSTALL) -Dpm 755 $(hal)/grub.cfg $(DESTDIR)/etc/grub.d/39_hal
	$(INSTALL) -Dpm 644 $(hal)/initrd.img $(DESTDIR)/boot/efi/EFI/gnu/hal-initrd.img
# Write the kernel in a dedicated location for persistent boot entries to use.
	$(INSTALL) -Dpm 644 $(hal)/vmlinuz $(DESTDIR)/boot/efi/EFI/gnu/hal-vmlinuz.efi
# Write the kernel where Apple systems will find it.  (This could overwrite existing system stuff.)
	$(INSTALL) -Dpm 644 $(hal)/vmlinuz $(DESTDIR)/boot/efi/System/Library/CoreServices/boot.efi
# Write the kernel where everything else will find it.  (This could overwrite existing system stuff.)
	$(INSTALL) -Dpm 644 $(hal)/vmlinuz $(DESTDIR)/boot/efi/EFI/BOOT/BOOTX64.EFI

.PHONY clean-hal: clean-hal-busybox clean-hal-linux-libre clean-hal-qemu

# Provide a sensible keymap for debugging the Linux environment.
$(hal)/emacs2.kbd: | $(hal)
	-loadkeys -bd emacs2 > $@ # This needs root user or tty group to work.
$(call prepared,hal): $(hal)/emacs2.kbd

# Provide the terminfo (stolen from ncurses-static) for QEMU text display.
$(hal)/linux.terminfo: | $(hal)
	$(COPY) /usr/share/terminfo/l/linux $@
$(call prepared,hal): $(hal)/linux.terminfo

# Provide the initialization script that launches QEMU.
$(hal)/init.sh: $(patchdir)/$(hal)-init.sh | $(hal)
	$(COPY) $< $@
$(call prepared,hal): $(hal)/init.sh

# Provide a DHCP network configuration script.
$(hal)/udhcpc.sh: | $(hal)
	$(ECHO) '#!/bin/ash -e' > $@
	$(ECHO) -e '[ "$$1" = bound -o "$$1" = deconfig -o "$$1" = renew ] || exit 0\n' >> $@
	$(ECHO) 'ifconfig "$${interface:=eth0}" "$${ip:-0.0.0.0}" '\\ >> $@
	$(ECHO) '    $${subnet:+netmask "$$subnet"} '\\ >> $@
	$(ECHO) -e '    $${broadcast:+broadcast "$$broadcast"}\n' >> $@
	$(ECHO) 'for gateway in $$router' >> $@
	$(ECHO) 'do route add default gw "$$gateway" dev "$$interface"' >> $@
	$(ECHO) -e 'done\n' >> $@
	$(ECHO) 'echo -n $${domain:+search "$$domain"$$'"'\n'} > /etc/resolv.conf" >> $@
	$(ECHO) 'for nameserver in $$dns' >> $@
	$(ECHO) 'do echo nameserver "$$nameserver" >> /etc/resolv.conf' >> $@
	$(ECHO) done >> $@
$(call prepared,hal): $(hal)/udhcpc.sh

# Provide a GRUB configuration that adds a virtualization boot option.
$(hal)/grub.cfg: | $(hal)
	$(ECHO) -e '#!/bin/tail -n+2\n' > $@
	$(ECHO) -e 'smbios --type 1 --get-string 4 --variable system_manufacturer\n' >> $@
	$(ECHO) "# If we're not running on the included virtual host, offer to boot it." >> $@
	$(ECHO) -e 'if [ "$$system_manufacturer" != "gnuxc" ] ; then\n' >> $@
	$(ECHO) "menuentry 'Boot a Virtual Machine for Compatibility' --class linux --class os {" >> $@
	$(ECHO) -e '\tinsmod part_msdos\n\tinsmod fat' >> $@
	$(ECHO) -e '\tsearch.file /EFI/gnu/hal-vmlinuz.efi root\n' >> $@
	$(ECHO) -e "\techo 'Loading Linux-libre ...'\n\tlinux /EFI/gnu/hal-vmlinuz.efi\n" >> $@
	$(ECHO) -e "\techo 'Loading QEMU ...'\n\tinitrd /EFI/gnu/hal-initrd.img\n}\n" >> $@
	$(ECHO) '# If we are on the VM host, use a theme variant advertising so (if one exists).' >> $@
	$(ECHO) -e 'elif [ -f "$$theme-vm" ] ; then\n  theme=$$theme-vm\nfi' >> $@
$(call prepared,hal): $(hal)/grub.cfg



$(hal-busybox): | $(hal)
	$(DOWNLOAD) '$(hal-busybox_url)' | $(TAR) -jC $(hal) -x

prepare-hal-busybox-rule: | $(hal-busybox)
	$(MAKE) -C $(hal-busybox) mrproper V=1

configure-hal-busybox-rule: $(call prepared,hal-busybox)
	$(MAKE) -C $(hal-busybox) allnoconfig V=1
	$(EDIT) $(hal-busybox)/.config \
		-e 's/^[# ]*\(CONFIG_STATIC\)[= ].*/\1=y/' \
		-e 's/^[# ]*\(CONFIG_EXTRA_CFLAGS\)[= ].*/\1="$(CFLAGS)"/' \
		-e 's/^[# ]*\(CONFIG_FEATURE_FANCY_ECHO\)[= ].*/\1=y/' \
		-e 's/^[# ]*\(CONFIG_SLEEP\)[= ].*/\1=y/' \
		-e 's/^[# ]*\(CONFIG_LOADKMAP\)[= ].*/\1=y/' \
		-e 's/^[# ]*\(CONFIG_FIND\)[= ].*/\1=y/' \
		-e 's/^[# ]*\(CONFIG_HALT\)[= ].*/\1=y/' \
		-e 's/^[# ]*\(CONFIG_MDEV\)[= ].*/\1=y/' \
		-e 's/^[# ]*\(CONFIG_FINDFS\)[= ].*/\1=y/' \
		-e 's/^[# ]*\(CONFIG_MOUNT\)[= ].*/\1=y/' \
		-e 's/^[# ]*\(CONFIG_VOLUMEID\)[= ].*/\1=y/' \
		-e 's/^[# ]*\(CONFIG_FEATURE_VOLUMEID_EXT\)[= ].*/\1=y/' \
		-e 's/^[# ]*\(CONFIG_IFCONFIG\)[= ].*/\1=y/' \
		-e 's/^[# ]*\(CONFIG_ROUTE\)[= ].*/\1=y/' \
		-e 's/^[# ]*\(CONFIG_UDHCPC\)[= ].*/\1=y/' \
		-e 's,^[# ]*\(CONFIG_UDHCPC_DEFAULT_SCRIPT\)[= ].*,\1="/usr/share/udhcpc/default.script",' \
		-e 's/^[# ]*\(CONFIG_FREE\)[= ].*/\1=y/' \
		-e 's/^[# ]*\(CONFIG_ASH\)[= ].*/\1=y/' \
		-e 's/^[# ]*\(CONFIG_ASH_BASH_COMPAT\)[= ].*/\1=y/' \
		-e 's/^[# ]*\(CONFIG_ASH_BUILTIN_ECHO\)[= ].*/\1=y/' \
		-e 's/^[# ]*\(CONFIG_ASH_BUILTIN_TEST\)[= ].*/\1=y/' \
		-e 's/^[# ]*\(CONFIG_ASH_OPTIMIZE_FOR_SIZE\)[= ].*/\1=y/' \
		-e 's/^[# ]*\(CONFIG_SH_MATH_SUPPORT\)[= ].*/\1=y/'

build-hal-busybox-rule: $(call configured,hal-busybox)
	$(MAKE) -C $(hal-busybox) all V=1 \
		CFLAGS_{dump,fflush_stdout_and_exit,wfopen,xfuncs_printf,ash,mount}.o=-Wno-error=format-security

clean-hal-busybox:
	$(RM) $(timedir)/{prepare,configure,build}-hal-busybox-{rule,stamp}
	$(RM) --recursive $(hal-busybox)



$(hal-linux-libre): | $(hal)
	$(DOWNLOAD) '$(hal-linux-libre_url)' | $(TAR) --transform='s,^$(hal-linux-libre_branch),$@,' -Jx

prepare-hal-linux-libre-rule: | $(hal-linux-libre)
	$(MAKE) -C $(hal-linux-libre) mrproper V=1
	$(PATCH) -d $(hal-linux-libre) < $(patchdir)/$(subst /,-,$(hal-linux-libre))-efistub-cmdline.patch

configure-hal-linux-libre-rule: $(call prepared,hal-linux-libre)
	$(MAKE) -C $(hal-linux-libre) allnoconfig V=1
	$(PATCH) -d $(hal-linux-libre) -bz .allno < $(hal)/linux-config.patch

build-hal-linux-libre-rule: $(call configured,hal-linux-libre)
	$(MAKE) -C $(hal-linux-libre) all V=1

clean-hal-linux-libre:
	$(RM) $(timedir)/{prepare,configure,build}-hal-linux-libre-{rule,stamp}
	$(RM) --recursive $(hal-linux-libre)

# Provide the Linux-libre configuration in a patch on top of "allnoconfig".
$(hal)/linux-config.patch: $(patchdir)/$(subst /,-,$(hal-linux-libre))-config.patch | $(hal)
	$(COPY) $< $@
$(call prepared,hal-linux-libre): $(hal)/linux-config.patch



$(hal-qemu): | $(hal)
	$(GIT) clone --branch $(hal-qemu_branch) --depth 1 '$(hal-qemu_url)' $@
	$(GIT) -C $@ submodule update --init pixman

prepare-hal-qemu-rule: | $(hal-qemu)
	$(PATCH) -d $(hal-qemu) -F2 -p1 < $(hal)/qemu-fbdev.patch
# Add pixman_image_get_format to the built-in pixman source.
	$(GIT) -C $(hal-qemu)/pixman cherry-pick 8f7cc5e4388e83eb1b77aea978f3c58338232320
	$(AUTOGEN) $(hal-qemu)/pixman

configure-hal-qemu-rule: $(call prepared,hal-qemu)
	cd $(hal-qemu) && env -i CFLAGS='$(CFLAGS)' PATH=/bin ./configure \
		--prefix=/usr --bindir=/bin --libdir=/lib --sysconfdir=/etc \
		--enable-curses --enable-fbdev \
		--enable-kvm \
		--enable-system --target-list=x86_64-softmmu \
		--static \
		--audio-drv-list= \
		--disable-{gtk,sdl,spice,vnc} \
		--disable-{blobs,docs,guest-agent,user,werror,xen} \
		--disable-{glusterfs,libssh2,virtfs} \
		--disable-{attr,bluez,brlapi,cap-ng,curl,linux-aio,uuid} \
		--disable-{libiscsi,libusb,smartcard-nss,usb-redir} \
		--disable-{fdt,rdma,seccomp,vde,vhost-net}
	cd $(hal-qemu)/pixman && env -i CFLAGS='$(CFLAGS)' PATH=/bin ./configure \
		--prefix=/usr \
		--disable-gtk \
		--disable-silent-rules \
		--disable-shared \
		--enable-static

build-hal-qemu-rule: $(call configured,hal-qemu)
	$(MAKE) -C $(hal-qemu) all V=1

clean-hal-qemu:
	$(RM) $(timedir)/{prepare,configure,build}-hal-qemu-{rule,stamp}
	$(RM) --recursive $(hal-qemu)

# Fetch the latest QEMU framebuffer patch from the mailing list archives.
$(hal)/qemu-devel-2013-06: | $(hal)
	$(DOWNLOAD) 'ftp://lists.gnu.org/qemu-devel/2013-06' > $@
$(hal)/qemu-fbdev.patch: $(hal)/qemu-devel-2013-06
	$(AWK) < $< \
		-e '/^From MAILER-/ { if (date && subj) p[subj] = msg; date = subj = msg = "" }' \
		-e '/^Date: Wed, 26 Jun 2013/ { date = 1 }' \
		-e '/^Subject: .Qemu-devel.* fbdev/ { subj = substr($$0, match($$0, /[12]/), 1) }' \
		-e '{ msg = msg $$0 "\n" }' \
		-e 'END { print p[1] p[2] }' | \
	$(SED) > $@ \
		-e 's/^@@ -1161,3 +1161,17 @@/@@ -1161,6 +1161,20 @@/' \
		-e 's/^diff.*Makefile.objs/ \n \n \n&/' \
		-e 's/^@@ -3608,3 +3608,46 @@/@@ -3608,6 +3608,49 @@/' \
		-e 's/^diff.*qmp-commands.hx/ \n \n \n&/' \
		-e '/^@@ -549,6 +550,7 @@/,+7d'
prepare-hal-qemu-rule: $(hal)/qemu-fbdev.patch
endif
