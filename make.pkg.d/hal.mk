hal                     := hal-1

hal-busybox             := busybox-1.27.2
hal-busybox_sha1        := 11669e223cc38de646ce26080e91ca29b8d42ad9
hal-busybox_url         := http://www.busybox.net/downloads/$(hal-busybox).tar.bz2

hal-linux-libre         := linux-libre-4.14.8
hal-linux-libre_branch  := $(hal-linux-libre:linux-libre-%=linux-%)
hal-linux-libre_key     := 474402C8C582DAFBE389C427BCB7CF877E7D47A7
hal-linux-libre_url     := http://linux-libre.fsfla.org/pub/linux-libre/releases/$(hal-linux-libre:linux-libre-%=%)-gnu/$(hal-linux-libre)-gnu.tar.lz
hal-linux-libre_sig     := $(hal-linux-libre_url).sign

hal-pixman              := pixman-0.34.0
hal-pixman_sha1         := 367698744e74d6d4f363041482965b9ea7fbe4a5
hal-pixman_url          := http://xorg.freedesktop.org/releases/individual/lib/$(hal-pixman).tar.bz2

hal-qemu                := qemu-2.11.0
hal-qemu_key            := CEACC9E15534EBABB82D3FA03353C9CEF108B584
hal-qemu_url            := http://download.qemu.org/$(hal-qemu).tar.xz

hal-wpa_supplicant      := wpa_supplicant-2.6
hal-wpa_supplicant_key  := EC4AA0A991A5F2464582D52D2B6EF432EFC895FA
hal-wpa_supplicant_url  := http://w1.fi/releases/$(hal-wpa_supplicant).tar.gz
hal-wpa_supplicant_sig  := $(hal-wpa_supplicant_url).asc

# Download all the sub-project sources.
$(eval $(call verify-download,$(hal-busybox).tar.bz2,$(hal-busybox_url),$(hal-busybox_sha1)))
$(eval $(call verify-download,$(hal-linux-libre).tar.lz,$(hal-linux-libre_url),$(hal-linux-libre_sig),$(hal-linux-libre_key)))
$(eval $(call verify-download,$(hal-pixman).tar.bz2,$(hal-pixman_url),$(hal-pixman_sha1)))
$(eval $(call verify-download,$(hal-qemu).tar.xz,$(hal-qemu_url),,$(hal-qemu_key)))
$(eval $(call verify-download,$(hal-wpa_supplicant).tar.gz,$(hal-wpa_supplicant_url),$(hal-wpa_supplicant_sig),$(hal-wpa_supplicant_key)))

# Download firmware for supported hardware.  (This could just be built from source, but it requires making an entire xtensa-elf cross-compiler toolchain.)
$(eval $(call verify-download,htc_9271-1.4.0.fw,http://git.kernel.org/cgit/linux/kernel/git/firmware/linux-firmware.git/plain/ath9k_htc/htc_9271-1.4.0.fw?id=3de1c437e75320c0d2f23dc990fac741f0bcc3ca,62686323432b63ec8091234f9b1b9ee6d746eec4))

ifneq ($(host),$(build))
$(prepare-rule): $(call prepared,busybox linux-libre pixman qemu wpa_supplicant)
#	t=../../../EFI/gnuxc/hal-vmlinuz.efi ; printf 'XSym\n%04u\n%.32s\n%-1024s' $${#t} "`echo -n $$t | md5sum`" $$t$$'\n' > $(builddir)/link.efi

$(configure-rule): $(call configured,busybox linux-libre qemu wpa_supplicant)
$(builddir)/configure: private override allow_rpaths = 1 # Don't mess with QEMU's configure scripts.

$(build-rule): $(call built,busybox linux-libre qemu wpa_supplicant)
	$(RM) --recursive $(builddir)/iroot && $(MKDIR) $(builddir)/iroot/{bin,dev,etc,proc,sbin,sys,usr/share/qemu}
	$(INSTALL) -Dpm 0755 $(call addon-file,init.sh) $(builddir)/iroot/init
	$(INSTALL) -Dpm 0644 $(call addon-file,emacs2.kbd) $(builddir)/iroot/usr/share/kbd/emacs2
	$(INSTALL) -Dpm 0644 $(call addon-file,linux.terminfo) $(builddir)/iroot/usr/share/terminfo/l/linux
	$(INSTALL) -Dpm 0755 $(call addon-file,udhcpc.sh) $(builddir)/iroot/usr/share/udhcpc/default.script
	$(INSTALL) -Dpm 0644 $(call addon-file,htc_9271-1.4.0.fw) $(builddir)/iroot/lib/firmware/ath9k_htc/htc_9271-1.4.0.fw
# Install BusyBox.
	$(INSTALL) -pm 0755 -st $(builddir)/iroot/sbin $(builddir)/$(hal-busybox)/busybox
	$(SYMLINK) ../sbin/busybox $(builddir)/iroot/bin/ash
	$(SYMLINK) ../sbin/busybox $(builddir)/iroot/bin/ctrl_is_down
	$(SYMLINK) ../sbin/busybox $(builddir)/iroot/bin/loadkmap
	$(SYMLINK) ../sbin/busybox $(builddir)/iroot/bin/mount
	$(SYMLINK) ../sbin/busybox $(builddir)/iroot/bin/sleep
	$(SYMLINK) busybox $(builddir)/iroot/sbin/findfs
	$(SYMLINK) busybox $(builddir)/iroot/sbin/ifconfig
	$(SYMLINK) busybox $(builddir)/iroot/sbin/poweroff
	$(SYMLINK) busybox $(builddir)/iroot/sbin/reboot
	$(SYMLINK) busybox $(builddir)/iroot/sbin/route
	$(SYMLINK) busybox $(builddir)/iroot/sbin/udhcpc
# Install the WPA supplicant.
	$(INSTALL) -pm 0755 -st $(builddir)/iroot/sbin $(builddir)/$(hal-wpa_supplicant)/wpa_supplicant/wpa_supplicant
# Install QEMU.
	$(INSTALL) -pm 0755 -st $(builddir)/iroot/bin $(builddir)/$(hal-qemu)/x86_64-softmmu/qemu-system-x86_64
	$(INSTALL) -pm 0644 -t $(builddir)/iroot/usr/share/qemu \
		$(builddir)/$(hal-qemu)/pc-bios/bios-256k.bin \
		$(builddir)/$(hal-qemu)/pc-bios/efi-pcnet.rom \
		$(builddir)/$(hal-qemu)/pc-bios/kvmvapic.bin \
		$(builddir)/$(hal-qemu)/pc-bios/vgabios-stdvga.bin
# Finalize.
	$(LINK) $(builddir)/$(hal-linux-libre)/arch/x86/boot/bzImage $(builddir)/vmlinuz
	(cd $(builddir)/iroot && find * | cpio -co) | gzip -9 > $(builddir)/initrd.img

$(install-rule):
	$(INSTALL) -Dpm 0755 $(call addon-file,grub.cfg) $(DESTDIR)/etc/grub.d/39_hal
# Write the files in a dedicated ESP location for persistent boot entries to use.
	$(INSTALL) -Dpm 0644 $(builddir)/vmlinuz $(DESTDIR)/boot/efi/EFI/gnuxc/hal-vmlinuz.efi
	$(INSTALL) -Dpm 0644 $(builddir)/initrd.img $(DESTDIR)/boot/efi/EFI/gnuxc/hal-initrd.img
# Write the kernel where Apple systems will find it.
	test -e $(DESTDIR)/boot/efi/System/Library/CoreServices/boot.efi && \
	$(ECHO) 'The Apple EFI boot program already exists; not overwiting' || \
	$(INSTALL) -Dpm 0644 $(builddir)/vmlinuz $(DESTDIR)/boot/efi/System/Library/CoreServices/boot.efi
# Write the kernel where everything else will find it.
	test -e $(DESTDIR)/boot/efi/EFI/BOOT/BOOTX64.EFI && \
	$(ECHO) 'The default EFI boot program already exists; not overwiting' || \
	$(INSTALL) -Dpm 0644 $(builddir)/vmlinuz $(DESTDIR)/boot/efi/EFI/BOOT/BOOTX64.EFI

# Write inline files.
$(call addon-file,busybox.config ctrl_is_down.c grub.cfg udhcpc.sh wpa_supplicant.config): | $$(@D)
	$(file >$@,$(contents))
$(prepared): $(call addon-file,grub.cfg udhcpc.sh)

# Provide a sensible keymap for debugging the Linux environment.
$(call addon-file,emacs2.kbd): | $$(@D)
	-loadkeys -bd emacs2 > $@ # This needs root user or tty group to work.
$(prepared): $(call addon-file,emacs2.kbd)

# Provide the terminfo (stolen from ncurses-static) for QEMU text display.
$(call addon-file,linux.terminfo): | $$(@D)
	$(COPY) /usr/share/terminfo/l/linux $@
$(prepared): $(call addon-file,linux.terminfo)

# Provide the initialization script that launches QEMU.
$(call addon-file,init.sh): $(patchdir)/$(hal)-init.sh | $$(@D)
	$(COPY) $< $@
$(prepared): $(call addon-file,init.sh)



$(builddir)/$(hal-busybox): | $(call addon-file,$(hal-busybox).tar.bz2)
	$(TAR) -C $(builddir) -xf $|

$(call prepare-rule,busybox): $(call addon-file,busybox.config ctrl_is_down.c) | $(builddir)/$(hal-busybox)
	$(MAKE) -C $(builddir)/$(hal-busybox) mrproper V=1
	$(COPY) $(call addon-file,busybox.config) $(builddir)/$(hal-busybox)/all.config.in
	$(COPY) $(call addon-file,ctrl_is_down.c) $(builddir)/$(hal-busybox)/console-tools/
# Disable rebooting through init, since we don't have a real init system.
	$(EDIT) '/ no -f /s/if (/&0 \&\& /' $(builddir)/$(hal-busybox)/init/halt.c

$(call configure-rule,busybox): $(call prepared,busybox)
	$(SED) $(builddir)/$(hal-busybox)/all.config.in > $(builddir)/$(hal-busybox)/all.config \
		-e '/^CONFIG[^ =]*_CFLAGS=/s/=.*/="$(CFLAGS_FOR_BUILD)"/' \
		-e '/^CONFIG[^ =]*_LDFLAGS=/s/=.*/="$(LDFLAGS_FOR_BUILD)"/'
	KCONFIG_ALLCONFIG=all.config $(MAKE) -C $(builddir)/$(hal-busybox) allnoconfig V=1

$(call build-rule,busybox): $(call configured,busybox)
	CFLAGS='$(CFLAGS_FOR_BUILD)' LDFLAGS='$(LDFLAGS_FOR_BUILD)' $(MAKE) -C $(builddir)/$(hal-busybox) all V=1 \
		CFLAGS_{dump,fflush_stdout_and_exit,wfopen,xfuncs_printf,ash,mount,decompress_gunzip}.o=-Wno-error=format-security



$(builddir)/$(hal-linux-libre): | $(call addon-file,$(hal-linux-libre).tar.lz)
	$(TAR) --transform='s,^$(hal-linux-libre_branch),$@,' -xf $|

$(call prepare-rule,linux-libre): $(call addon-file,linux.config) | $(builddir)/$(hal-linux-libre)
	$(MAKE) -C $(builddir)/$(hal-linux-libre) mrproper V=1
	$(PATCH) -d $(builddir)/$(hal-linux-libre) < $(patchdir)/$(hal-linux-libre)-efistub-cmdline.patch
	$(COPY) $< $(builddir)/$(hal-linux-libre)/all.config

$(call configure-rule,linux-libre): $(call prepared,linux-libre)
	KCONFIG_ALLCONFIG=all.config $(MAKE) -C $(builddir)/$(hal-linux-libre) allnoconfig V=1

$(call build-rule,linux-libre): $(call configured,linux-libre)
	$(MAKE) -C $(builddir)/$(hal-linux-libre) all V=1

# Provide a minimal set of Linux configuration options.
$(call addon-file,linux.config): $(patchdir)/$(hal)-linux.config | $$(@D)
	$(COPY) $< $@



$(builddir)/$(hal-pixman): | $(call addon-file,$(hal-pixman).tar.bz2)
	$(TAR) -C $(builddir) -xf $|

$(call prepare-rule,pixman): | $(builddir)/$(hal-pixman)

$(call configure-rule,pixman): $(call prepared,pixman)
	cd $(builddir)/$(hal-pixman) && $(native) ./configure \
		--prefix=/usr \
		--disable-gtk \
		--disable-libpng \
		--disable-shared \
		--disable-silent-rules \
		--enable-static

$(call build-rule,pixman): $(call configured,pixman)
	$(MAKE) -C $(builddir)/$(hal-pixman) all



$(builddir)/$(hal-qemu): | $(call addon-file,$(hal-qemu).tar.xz)
	$(TAR) -C $(builddir) -xf $|

$(call prepare-rule,qemu): | $(builddir)/$(hal-qemu)
	$(PATCH) -d $(builddir)/$(hal-qemu) < $(patchdir)/$(hal-qemu)-fbdev.patch
	$(PATCH) -d $(builddir)/$(hal-qemu) < $(patchdir)/$(hal-qemu)-python3.patch
# Work around the ncurses pkgconfig file.
	$(EDIT) 's/ --libs ncursesw [^:]*/& -ldl/' $(builddir)/$(hal-qemu)/configure

$(call configure-rule,qemu): private override export LDFLAGS_FOR_BUILD := $(LDFLAGS_FOR_BUILD) -L'$(CURDIR)/$(builddir)/$(hal-pixman)/pixman/.libs'
$(call configure-rule,qemu): $(call prepared,qemu) $(call built,pixman)
	cd $(builddir)/$(hal-qemu) && $(native) PYTHON=$(PYTHON) ./configure \
		--prefix=/usr --bindir=/bin --libdir=/lib --sysconfdir=/etc \
		--audio-drv-list=oss \
		--enable-curses --enable-fbdev \
		--enable-kvm \
		--enable-system --target-list=x86_64-softmmu \
		--static \
		--disable-{gtk,sdl,spice,vnc} \
		--disable-{blobs,docs,guest-agent,user,werror,xen} \
		--disable-{glusterfs,libssh2,virtfs} \
		--disable-{gcrypt,gnutls,nettle} \
		--disable-{attr,bluez,brlapi,cap-ng,curl,linux-aio} \
		--disable-{libiscsi,libusb,smartcard,usb-redir} \
		--disable-{fdt,rdma,seccomp,vde,vhost-net,vhost-scsi}

$(call build-rule,qemu): $(call configured,qemu)
	$(MAKE) -C $(builddir)/$(hal-qemu) all V=1



$(builddir)/$(hal-wpa_supplicant): | $(call addon-file,$(hal-wpa_supplicant).tar.gz)
	$(TAR) -C $(builddir) -xf $|

$(call prepare-rule,wpa_supplicant): $(call addon-file,wpa_supplicant.config) | $(builddir)/$(hal-wpa_supplicant)
	$(COPY) $< $(builddir)/$(hal-wpa_supplicant)/wpa_supplicant/.config

$(call configure-rule,wpa_supplicant): $(call prepared,wpa_supplicant)

$(call build-rule,wpa_supplicant): $(call configured,wpa_supplicant)
	$(native) $(MAKE) -C $(builddir)/$(hal-wpa_supplicant)/wpa_supplicant all V=1
endif



# Provide a minimal set of BusyBox configuration options.
override define contents
CONFIG_STATIC=y
CONFIG_EXTRA_CFLAGS="$(CFLAGS_FOR_BUILD)"
CONFIG_EXTRA_LDFLAGS="$(LDFLAGS_FOR_BUILD)"
CONFIG_FEATURE_FANCY_ECHO=y
CONFIG_SLEEP=y
CONFIG_CTRL_IS_DOWN=y
CONFIG_LOADKMAP=y
CONFIG_POWEROFF=y
CONFIG_REBOOT=y
CONFIG_FINDFS=y
CONFIG_MOUNT=y
CONFIG_VOLUMEID=y
CONFIG_FEATURE_VOLUMEID_EXT=y
CONFIG_FEATURE_VOLUMEID_FAT=y
CONFIG_IFCONFIG=y
CONFIG_ROUTE=y
CONFIG_UDHCPC=y
CONFIG_UDHCPC_DEFAULT_SCRIPT="/usr/share/udhcpc/default.script"
CONFIG_ASH=y
CONFIG_ASH_BASH_COMPAT=y
CONFIG_ASH_ECHO=y
CONFIG_ASH_TEST=y
CONFIG_ASH_OPTIMIZE_FOR_SIZE=y
CONFIG_FEATURE_SH_MATH=y
CONFIG_SH_IS_NONE=y
endef
$(call addon-file,busybox.config): private override contents := $(contents)


# Provide a minimal set of wpa_supplicant configuration options.
override define contents
LDFLAGS+=-static
# Use the wireless extensions driver to avoid needing libnl.
CONFIG_DRIVER_WEXT=y
# Don't require an external TLS library.
CONFIG_INTERNAL_LIBTOMMATH=y
CONFIG_INTERNAL_LIBTOMMATH_FAST=y
CONFIG_TLS=internal
# We only read a text configuration file.
CONFIG_NO_CONFIG_BLOBS=y
CONFIG_NO_CONFIG_WRITE=y
endef
$(call addon-file,wpa_supplicant.config): private override contents := $(contents)


# Provide a BusyBox applet to test if Control is being held on boot.
override define contents
#include "libbb.h"
//config:config $1
//config:	bool "$1"
//kbuild:lib-$$(CONFIG_$1) += $2.o
//applet:IF_$1(APPLET($2, BB_DIR_USR_BIN, BB_SUID_DROP))
//usage:#define $2_trivial_usage ""
#define main(...) $2_main(__VA_ARGS__) MAIN_EXTERNALLY_VISIBLE
endef
override define contents :=
$(call contents,CTRL_IS_DOWN,ctrl_is_down)
#include <linux/keyboard.h>
#include <sys/ioctl.h>
int main() {
  char shift_state = 6;
  if (ioctl(0, TIOCLINUX, &shift_state) < 0)
    return 1;
  return !(shift_state & (1 << KG_CTRL));
}
endef
$(call addon-file,ctrl_is_down.c): private override contents := $(value contents)


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


# Provide a GRUB configuration file that adds a virtualization boot option.
override define contents
#!/bin/tail -n+2
smbios --type 1 --get-string 4 --set system_manufacturer

# If we're not running on the included virtual host, offer to boot it.
if [ "$system_manufacturer" != "gnuxc" ] ; then

menuentry 'Boot a Virtual Machine for Compatibility' --class linux --class os {
	insmod part_msdos
	insmod fat
	search.file /EFI/gnuxc/hal-vmlinuz.efi root

	echo 'Loading Linux-libre ...'
	linux /EFI/gnuxc/hal-vmlinuz.efi

	echo 'Loading QEMU ...'
	initrd /EFI/gnuxc/hal-initrd.img
}

# If we are in the VM, use a theme variant advertising so (if one exists).
elif [ -f "$theme-vm" ] ; then
  theme=$theme-vm
fi
endef
$(call addon-file,grub.cfg): private override contents := $(value contents)
