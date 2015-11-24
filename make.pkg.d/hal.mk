hal                     := hal-1

hal-busybox             := busybox-1.24.1
hal-busybox_url         := http://www.busybox.net/downloads/$(hal-busybox).tar.bz2

hal-linux-libre         := linux-libre-4.3
hal-linux-libre_branch  := $(hal-linux-libre:linux-libre-%=linux-%)
hal-linux-libre_url     := http://linux-libre.fsfla.org/pub/linux-libre/releases/$(hal-linux-libre:linux-libre-%=%)-gnu/$(hal-linux-libre)-gnu.tar.xz

hal-qemu                := qemu-1.7.2
hal-qemu_branch         := $(hal-qemu:qemu-%=v%)
hal-qemu_url            := git://git.qemu.org/qemu.git

ifneq ($(host),$(build))
$(prepare-rule): $(call prepared,busybox linux-libre qemu)
#	t=../../../EFI/gnu/hal-vmlinuz.efi ; printf 'XSym\n%04u\n%.32s\n%-1024s' $${#t} "`echo -n $$t | md5sum`" $$t$$'\n' > $(builddir)/link.efi

$(configure-rule): $(call configured,busybox linux-libre qemu)

$(build-rule): $(call built,busybox linux-libre qemu)
	$(RM) --recursive $(builddir)/iroot && $(MKDIR) $(builddir)/iroot/{bin,dev,etc,proc,sbin,sys,usr/share/qemu}
	$(INSTALL) -Dpm 755 $(call addon-file,init.sh) $(builddir)/iroot/init
	$(INSTALL) -Dpm 644 $(call addon-file,emacs2.kbd) $(builddir)/iroot/usr/share/kbd/emacs2
	$(INSTALL) -Dpm 644 $(call addon-file,linux.terminfo) $(builddir)/iroot/usr/share/terminfo/l/linux
	$(INSTALL) -Dpm 755 $(call addon-file,udhcpc.sh) $(builddir)/iroot/usr/share/udhcpc/default.script
# Install BusyBox.
	$(INSTALL) -pm 755 -st $(builddir)/iroot/sbin $(builddir)/$(hal-busybox)/busybox
	$(SYMLINK) ../sbin/busybox $(builddir)/iroot/bin/ash
	$(SYMLINK) ../sbin/busybox $(builddir)/iroot/bin/loadkmap
	$(SYMLINK) ../sbin/busybox $(builddir)/iroot/bin/mount
	$(SYMLINK) ../sbin/busybox $(builddir)/iroot/bin/sleep
	$(SYMLINK) busybox $(builddir)/iroot/sbin/findfs
	$(SYMLINK) busybox $(builddir)/iroot/sbin/ifconfig
	$(SYMLINK) busybox $(builddir)/iroot/sbin/mdev
	$(SYMLINK) busybox $(builddir)/iroot/sbin/poweroff
	$(SYMLINK) busybox $(builddir)/iroot/sbin/reboot
	$(SYMLINK) busybox $(builddir)/iroot/sbin/route
	$(SYMLINK) busybox $(builddir)/iroot/sbin/udhcpc
# Install QEMU.
	$(INSTALL) -pm 755 -st $(builddir)/iroot/bin $(builddir)/$(hal-qemu)/x86_64-softmmu/qemu-system-x86_64
	$(INSTALL) -pm 644 -t $(builddir)/iroot/usr/share/qemu \
		$(builddir)/$(hal-qemu)/pc-bios/bios.bin \
		$(builddir)/$(hal-qemu)/pc-bios/efi-rtl8139.rom \
		$(builddir)/$(hal-qemu)/pc-bios/kvmvapic.bin \
		$(builddir)/$(hal-qemu)/pc-bios/vgabios-stdvga.bin
# Finalize.
	$(LINK) $(builddir)/$(hal-linux-libre)/arch/x86/boot/bzImage $(builddir)/vmlinuz
	(cd $(builddir)/iroot && find * | cpio -co) | gzip -9 > $(builddir)/initrd.img

$(install-rule):
	$(INSTALL) -Dpm 755 $(call addon-file,grub.cfg) $(DESTDIR)/etc/grub.d/39_hal
	$(INSTALL) -Dpm 644 $(builddir)/initrd.img $(DESTDIR)/boot/efi/EFI/gnu/hal-initrd.img
# Write the kernel in a dedicated location for persistent boot entries to use.
	$(INSTALL) -Dpm 644 $(builddir)/vmlinuz $(DESTDIR)/boot/efi/EFI/gnu/hal-vmlinuz.efi
# Write the kernel where Apple systems will find it.  (This could overwrite existing system stuff.)
	$(INSTALL) -Dpm 644 $(builddir)/vmlinuz $(DESTDIR)/boot/efi/System/Library/CoreServices/boot.efi
# Write the kernel where everything else will find it.  (This could overwrite existing system stuff.)
	$(INSTALL) -Dpm 644 $(builddir)/vmlinuz $(DESTDIR)/boot/efi/EFI/BOOT/BOOTX64.EFI

# Write inline files.
$(call addon-file,busybox.config grub.cfg udhcpc.sh): | $$(@D)
	$(file >$@,$(contents))
$(prepared): $(call addon-file,busybox.config grub.cfg udhcpc.sh)

# Provide a sensible keymap for debugging the Linux environment.
$(call addon-file,emacs2.kbd): | $$(@D)
	-loadkeys -bd emacs2 > $@ # This needs root user or tty group to work.
$(prepared): $(call addon-file,emacs2.kbd)

# Provide the terminfo (stolen from ncurses-static) for QEMU text display.
$(call addon-file,linux.terminfo): | $$(@D)
	$(COPY) /usr/share/terminfo/l/linux $@
$(prepared): $(call addon-file,linux.terminfo)

# Provide a minimal set of Linux configuration options.
$(call addon-file,linux.config): $(patchdir)/$(hal)-linux.config | $$(@D)
	$(COPY) $< $@
$(prepared): $(call addon-file,linux.config)

# Provide the initialization script that launches QEMU.
$(call addon-file,init.sh): $(patchdir)/$(hal)-init.sh | $$(@D)
	$(COPY) $< $@
$(prepared): $(call addon-file,init.sh)



$(builddir)/$(hal-busybox): | $(builddir)/.gnuxc
	$(DOWNLOAD) '$(hal-busybox_url)' | $(TAR) -jC $(builddir) -x

$(call prepare-rule,busybox): $(call addon-file,busybox.config) | $(builddir)/$(hal-busybox)
	$(MAKE) -C $(builddir)/$(hal-busybox) mrproper V=1
	$(COPY) $< $(builddir)/$(hal-busybox)/all.config.in

$(call configure-rule,busybox): private override export KCONFIG_ALLCONFIG = all.config
$(call configure-rule,busybox): $(call prepared,busybox)
	$(SED) $(builddir)/$(hal-busybox)/all.config.in > $(builddir)/$(hal-busybox)/all.config \
		-e '/^CONFIG[^ =]*_CFLAGS=/s/=.*/="$(CFLAGS)"/' \
		-e '/^CONFIG[^ =]*_LDFLAGS=/s/=.*/="$(LDFLAGS)"/'
	$(MAKE) -C $(builddir)/$(hal-busybox) allnoconfig V=1

$(call build-rule,busybox): $(call configured,busybox)
	$(MAKE) -C $(builddir)/$(hal-busybox) all V=1 \
		CFLAGS_{dump,fflush_stdout_and_exit,wfopen,xfuncs_printf,ash,mount}.o=-Wno-error=format-security



$(builddir)/$(hal-linux-libre): | $(builddir)/.gnuxc
	$(DOWNLOAD) '$(hal-linux-libre_url)' | $(TAR) --transform='s,^$(hal-linux-libre_branch),$@,' -Jx

$(call prepare-rule,linux-libre): $(call addon-file,linux.config) | $(builddir)/$(hal-linux-libre)
	$(MAKE) -C $(builddir)/$(hal-linux-libre) mrproper V=1
	$(PATCH) -d $(builddir)/$(hal-linux-libre) < $(patchdir)/$(hal-linux-libre)-efistub-cmdline.patch
	$(COPY) $< $(builddir)/$(hal-linux-libre)/all.config

$(call configure-rule,linux-libre): private override export KCONFIG_ALLCONFIG = all.config
$(call configure-rule,linux-libre): $(call prepared,linux-libre)
	$(MAKE) -C $(builddir)/$(hal-linux-libre) allnoconfig V=1

$(call build-rule,linux-libre): $(call configured,linux-libre)
	$(MAKE) -C $(builddir)/$(hal-linux-libre) all V=1



$(builddir)/$(hal-qemu): | $(builddir)/.gnuxc
	$(GIT) clone --branch $(hal-qemu_branch) --depth 1 '$(hal-qemu_url)' $@
	$(GIT) -C $@ submodule update --init pixman
	$(GIT) -C $@/pixman cherry-pick 8f7cc5e4388e83eb1b77aea978f3c58338232320

$(call prepare-rule,qemu): $(call addon-file,qemu-fbdev.patch) | $(builddir)/$(hal-qemu)
	$(PATCH) -d $(builddir)/$(hal-qemu) -F2 -p1 < $<
	$(AUTOGEN) $(builddir)/$(hal-qemu)/pixman

$(call configure-rule,qemu): $(call prepared,qemu)
	cd $(builddir)/$(hal-qemu) && env -i CFLAGS='$(CFLAGS)' PATH=/bin ./configure \
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
		--disable-{fdt,rdma,seccomp,vde,vhost-net} \
		\
		--without-system-pixman
	cd $(builddir)/$(hal-qemu)/pixman && env -i CFLAGS='$(CFLAGS)' PATH=/bin ./configure \
		--prefix=/usr \
		--disable-gtk \
		--disable-silent-rules \
		--disable-shared \
		--enable-static

$(call build-rule,qemu): $(call configured,qemu)
	$(MAKE) -C $(builddir)/$(hal-qemu) all V=1

# Fetch the latest QEMU framebuffer patch from the mailing list archives.
$(call addon-file,qemu-fbdev.patch.orig): | $$(@D)
	$(DOWNLOAD) 'ftp://lists.gnu.org/qemu-devel/2013-06' | $(AWK) > $@ \
		-e '/^From MAILER-/ { if (date && subj) p[subj] = msg; date = subj = msg = "" }' \
		-e '/^Date: Wed, 26 Jun 2013/ { date = 1 }' \
		-e '/^Subject: .Qemu-devel.* fbdev/ { subj = substr($$0, match($$0, /[12]/), 1) }' \
		-e '{ msg = msg $$0 "\n" }' \
		-e 'END { print p[1] p[2] }'
$(call addon-file,qemu-fbdev.patch): $(call addon-file,qemu-fbdev.patch.orig)
	$(SED) < $< > $@ \
		-e '### Make the patch apply on current QEMU 1.*' \
		-e 's/^@@ -1161,3 +1161,17 @@/@@ -1161,6 +1161,20 @@/' \
		-e 's/^diff.*Makefile.objs/ \n \n \n&/' \
		-e 's/^@@ -3608,3 +3608,46 @@/@@ -3608,6 +3608,49 @@/' \
		-e 's/^diff.*qmp-commands.hx/ \n \n \n&/' \
		-e '/^@@ -549,6 +550,7 @@/,+7d' \
	;:	\
		-e '### Make the patch apply on current QEMU 2.*' \
		-e 's/^ sdl=""/ sdlabi="1.2"/' \
		-e '/^\([ +]\)echo ".*able/s/echo "\(.*\)"/\1/' \
		-e 's/enable-gtk.*/with-gtkabi            select preferred GTK ABI 2.0 or 3.0/' \
		-e '/curses support/{s/curses/VTE/;s/.curses/   $$vte/;}' \
		-e 's/vnc=<.*]/gtk[,grab_on_hover=on|off]|/' \
		-e '/^--- a.hmp.h/,/^diff/{s/^@@.*@@/@@ -86,4 +86,5 @@/;/^ $$/d;s/.*_io.*/ /;}' \
		\
		-e '### Make the patch compile on current QEMU 2.* (incomplete)' \
		-e 's/1164 /1165 /;/"sysemu/a+#include "trace.h"' \
		-e 's/kbd_mouse_is_absolute/qemu_input_is_absolute/' \
		-e 's/error_is_set(&\([^)]*\))/(\1)/;s/error_is_set(\([^)]*\))/(\1 \&\& *\1)/'
endif



# Provide a minimal set of BusyBox configuration options.
override define contents
CONFIG_STATIC=y
CONFIG_EXTRA_CFLAGS="$(CFLAGS)"
CONFIG_EXTRA_LDFLAGS="$(LDFLAGS)"
CONFIG_FEATURE_FANCY_ECHO=y
CONFIG_SLEEP=y
CONFIG_LOADKMAP=y
CONFIG_HALT=y
CONFIG_MDEV=y
CONFIG_FINDFS=y
CONFIG_MOUNT=y
CONFIG_VOLUMEID=y
CONFIG_FEATURE_VOLUMEID_EXT=y
CONFIG_IFCONFIG=y
CONFIG_ROUTE=y
CONFIG_UDHCPC=y
CONFIG_UDHCPC_DEFAULT_SCRIPT="/usr/share/udhcpc/default.script"
CONFIG_ASH=y
CONFIG_ASH_BASH_COMPAT=y
CONFIG_ASH_BUILTIN_ECHO=y
CONFIG_ASH_BUILTIN_TEST=y
CONFIG_ASH_OPTIMIZE_FOR_SIZE=y
CONFIG_FEATURE_SH_IS_NONE=y
CONFIG_SH_MATH_SUPPORT=y
endef
$(call addon-file,busybox.config): private override contents := $(contents)


# Provide a DHCP network configuration script.
override define contents
#!/bin/ash -e
[ "$1" = bound -o "$1" = deconfig -o "$1" = renew ] || exit 0

ifconfig "${interface:=eth0}" "${ip:-0.0.0.0}" ^
    ${subnet:+netmask "$subnet"} ^
    ${broadcast:+broadcast "$broadcast"}

for gateway in $router
do route add default gw "$gateway" dev "$interface"
done

echo -n ${domain:+search "$domain"$'\n'} > /etc/resolv.conf
for nameserver in $dns
do echo nameserver "$nameserver" >> /etc/resolv.conf
done
endef
$(call addon-file,udhcpc.sh): private override contents := $(subst ^,\,$(value contents))


# Provide a GRUB configuration that adds a virtualization boot option.
override define contents
#!/bin/tail -n+2
smbios --type 1 --get-string 4 --set system_manufacturer

# If we're not running on the included virtual host, offer to boot it.
if [ "$system_manufacturer" != "gnuxc" ] ; then

menuentry 'Boot a Virtual Machine for Compatibility' --class linux --class os {
	insmod part_msdos
	insmod fat
	search.file /EFI/gnu/hal-vmlinuz.efi root

	echo 'Loading Linux-libre ...'
	linux /EFI/gnu/hal-vmlinuz.efi

	echo 'Loading QEMU ...'
	initrd /EFI/gnu/hal-initrd.img
}

# If we are in the VM, use a theme variant advertising so (if one exists).
elif [ -f "$theme-vm" ] ; then
  theme=$theme-vm
fi
endef
$(call addon-file,grub.cfg): private override contents := $(value contents)
