# GNU OS Cross-Compiler - Hardware Abstraction Layer

This is a *draft* document to create a minimal virtualization option at boot
time based on Linux and QEMU.  It is intended to act as a fairly transparent
hardware abstraction layer for the guest OS.  Here are the caveats:

The steps below are written for Fedora 20 as the development platform, but they
should translate to other environments trivially.

Currently, this procedure focuses on patching, building, and packaging QEMU.
Compiling a custom Linux kernel is outside the scope of this document, so the
kernel and busybox binaries from Fedora are used as-is.

Finally, the init script only prepares for virtual hardware to remain minimal
and generally testable.  (Mostly--run `s/intel/amd/g` on this file if you have
an AMD CPU.)  Preparing drivers for your target hardware or scanning `sysfs` to
handle it automatically is left as an exercise for the reader.



## Prepare Sources

To build a static QEMU binary, a few static libraries are required.  Fedora 20
doesn't have a `glib2-static` package, but it is built in rawhide.  Get as much
as possible from the release repository, then upgrade `glib2` from rawhide.

    sudo yum -y install fedora-release-rawhide \
        glibc-static glib2-devel zlib-static
    sudo yum --enablerepo=rawhide install glib2-static

Retrieve the source for QEMU version 1.6.1.  The build will require a static
pixman library which does not exist in Fedora, so use QEMU's included copy.
(Uninstall `pixman-devel` to avoid issues with this.)

    git clone --branch v1.6.1 --depth 1 git://git.qemu.org/qemu.git qemu-1.6.1
    git -C qemu-1.6.1 submodule update --init pixman

Extract the latest iteration of the framebuffer patches from the QEMU mailing
list archives.  This will find the messages based on subject and date.

    wget -qO- ftp://lists.gnu.org/qemu-devel/2013-06 | awk > fbdev.patch.orig '
    /^From MAILER-/ { if (date && subj) p[subj] = msg; date = subj = msg = "" }
    /^Date: Wed, 26 Jun 2013/ { date = 1 }
    /^Subject: .Qemu-devel.* fbdev/ { subj = substr($0, match($0, /[12]/), 1) }
    { msg = msg $0 "\n" }
    END { print p[1] p[2] }'

Make a slight adjustment for EOF hunks that are no longer at EOF in 1.6.1.

    sed < fbdev.patch.orig > fbdev.patch \
        -e 's/^@@ -1161,3 +1161,17 @@/@@ -1161,6 +1161,20 @@/' \
        -e 's/^diff.*Makefile.objs/ \n \n \n&/' \
        -e 's/^@@ -3608,3 +3608,46 @@/@@ -3608,6 +3608,49 @@/' \
        -e 's/^diff.*qmp-commands.hx/ \n \n \n&/'

The bundled version of pixman needs a new function for building the patch.

    sed qemu-1.6.1/pixman/pixman/pixman.h -i -e '780a\
            pixman_format_code_t pixman_image_get_format (pixman_image_t *);'
    cat << 'EOF' >> qemu-1.6.1/pixman/pixman/pixman-image.c
    PIXMAN_EXPORT pixman_format_code_t
    pixman_image_get_format (pixman_image_t *image)
    {
        if (image->type == BITS)
            return image->bits.format;
        return PIXMAN_null;
    }
    EOF

Apply the framebuffer patch.  It may complain about offsets and fuzz, but every
piece should apply successfully.

    patch -d qemu-1.6.1 -p1 < fbdev.patch



## Build QEMU

These are the important points for minimal QEMU configuration.

  * Choose to build a static binary.
  * Build the `x86_64` system target.
  * Enable framebuffer video output.
  * Leave SLIRP enabled for `user` network devices.
  * Enable KVM.
  * Disable everything else.

Configure QEMU according to the above requirements.

    (cd qemu-1.6.1
    export CFLAGS="$(rpm -E %__global_cflags)"
    export LDFLAGS="$(rpm -E %__global_ldflags)"
    ./configure \
        --static \
        --enable-system --target-list=x86_64-softmmu \
        --enable-fbdev \
        --enable-kvm \
        --prefix=/usr --bindir=/bin --libdir=/lib --sysconfdir=/etc \
        --disable-{curses,gtk,sdl,spice,vnc} \
        --disable-{blobs,docs,guest-agent,user,werror,xen} \
        --disable-{glusterfs,libssh2,virtfs} \
        --disable-{attr,bluez,brlapi,cap-ng,curl,linux-aio,uuid} \
        --disable-{libiscsi,libusb,smartcard-nss,usb-redir} \
        --disable-{fdt,rdma,seccomp,vde,vhost-net} )

Compile QEMU.

    make -C qemu-1.6.1 $(rpm -E %_smp_mflags) V=1



## Assemble the RAM Disk

Create the directory skeleton.

    mkdir -p rdroot/{bin,dev/input,etc,lib,usr/share/{qemu,udhcpc}}

Write the initialization script.  Its sole purpose in life is to prepare the
Linux environment for launching QEMU.  This is where customizations need to go
for your target platform, such as replacing the virtual drivers, increasing
guest resources, or even configuring a firewall.

    cat << 'EOF' > rdroot/init && chmod 755 rdroot/init
    #!/bin/ash -e
    abort() { echo 'Init failed!' 1>&2 ; exec ash ; } ; trap abort EXIT

    # Support KVM
    insmod /lib/kvm.ko
    insmod /lib/kvm-intel.ko            # hardware dependent
    mknod -m 666 /dev/kvm c 10 232

    # Support fbdev
    insmod /lib/i2c-core.ko
    insmod /lib/drm.ko
    insmod /lib/drm_kms_helper.ko
    insmod /lib/ttm.ko                  # hardware dependent
    insmod /lib/qxl.ko                  # hardware dependent
    mknod -m 660 /dev/fb0 c 29 0

    # Support mice
    mknod -m 600 /dev/input/mice c 13 63

    # Support networking
    insmod /lib/virtio.ko               # hardware dependent
    insmod /lib/virtio_ring.ko          # hardware dependent
    insmod /lib/virtio_pci.ko           # hardware dependent
    insmod /lib/virtio_net.ko           # hardware dependent
    ifconfig eth0 up
    udhcpc

    # Support virtio-rng
    mknod -m 666 /dev/random c 1 8

    # Support hard disk
    mknod -m 660 /dev/sda b 8 0

    qemu-system-x86_64 -nodefaults \
        -machine accel=kvm -enable-kvm \
        -cpu host -smp cores=1 -m 1G \
        -display fbdev -vga std \
        -netdev user,id=eth0 -device rtl8139,netdev=eth0 \
        -device virtio-rng-pci \
        -hda /dev/sda

    exec poweroff -f
    EOF

Configure the network at runtime with DHCP.

    cat << 'EOF' > rdroot/usr/share/udhcpc/default.script
    #!/bin/ash -e
    [ "$1" = bound -o "$1" = deconfig -o "$1" = renew ] || exit 0

    ifconfig "${interface:=eth0}" "${ip:-0.0.0.0}" \
        ${subnet:+netmask "$subnet"} \
        ${broadcast:+broadcast "$broadcast"}

    for gateway in $router
    do route add default gw "$gateway" dev "$interface"
    done

    echo -n ${domain:+search "$domain"$'\n'} > /etc/resolv.conf
    for nameserver in $dns
    do echo nameserver "$nameserver" >> /etc/resolv.conf
    done
    EOF
    chmod 755 rdroot/usr/share/udhcpc/default.script

Install `busybox`, and alias all the useful commands.

    install -pm 755 -t rdroot/bin /sbin/busybox
    ln -s busybox rdroot/bin/ash
    ln -s busybox rdroot/bin/ifconfig
    ln -s busybox rdroot/bin/insmod
    ln -s busybox rdroot/bin/mknod
    ln -s busybox rdroot/bin/poweroff
    ln -s busybox rdroot/bin/route
    ln -s busybox rdroot/bin/udhcpc

Install copies of the required kernel modules.

    install -pm 644 -t rdroot/lib \
        /lib/modules/$(uname -r)/kernel/arch/x86/kvm/kvm.ko \
        /lib/modules/$(uname -r)/kernel/arch/x86/kvm/kvm-intel.ko \
        \
        /lib/modules/$(uname -r)/kernel/drivers/i2c/i2c-core.ko \
        /lib/modules/$(uname -r)/kernel/drivers/gpu/drm/drm.ko \
        /lib/modules/$(uname -r)/kernel/drivers/gpu/drm/drm_kms_helper.ko \
        \
        /lib/modules/$(uname -r)/kernel/drivers/gpu/drm/ttm/ttm.ko \
        /lib/modules/$(uname -r)/kernel/drivers/gpu/drm/qxl/qxl.ko \
        \
        /lib/modules/$(uname -r)/kernel/drivers/virtio/virtio.ko \
        /lib/modules/$(uname -r)/kernel/drivers/virtio/virtio_ring.ko \
        /lib/modules/$(uname -r)/kernel/drivers/virtio/virtio_pci.ko \
        /lib/modules/$(uname -r)/kernel/drivers/net/virtio_net.ko

Install the static QEMU and its BIOS files for guest hardware.

    install -pm 755 -st rdroot/bin qemu-1.6.1/x86_64-softmmu/qemu-system-x86_64
    install -pm 644 -t rdroot/usr/share/qemu \
        qemu-1.6.1/pc-bios/bios.bin \
        qemu-1.6.1/pc-bios/efi-rtl8139.rom \
        qemu-1.6.1/pc-bios/kvmvapic.bin \
        qemu-1.6.1/pc-bios/vgabios-stdvga.bin

Build the initrd image.

    sudo chown -hR 0:0 rdroot
    (cd rdroot && find * | cpio -co) | gzip -9 > initrd-$(uname -r).img



## Test Virtually

If you would like to test this in a virtual machine before making a physical
disk, you'll need to verify nested KVM is working.  This command will tell you
if it's ready.

    cat /sys/module/kvm_intel/parameters/nested

If the output is `N` or `0`, it's not enabled.  Write a configuration file for
`modprobe` to set this property, and reload the module to pick up the change.

    echo 'options kvm-intel nested=1' | sudo tee /etc/modprobe.d/kvm-intel.conf
    sudo rmmod kvm-intel && sudo modprobe kvm-intel

When you check the paramater again, it should output `Y` or `1`.  Given that,
run the following to test whether the static QEMU can boot a disk image.

    qemu-kvm -nodefaults \
        -machine accel=kvm -enable-kvm \
        -cpu host -smp cores=1 -m 2G \
        -display sdl -vga qxl \
        -netdev user,id=eth0 -device virtio-net-pci,netdev=eth0 \
        -kernel /boot/vmlinuz-$(uname -r) -initrd initrd-$(uname -r).img \
        -hda gnu.img

The init script will abort if any step fails, and it will present you with a
shell prompt to try to rescue the system.  If it makes it to virtually booting
the disk, pressing `Ctrl+Alt+Escape` will terminate the guest and cause init to
abort to the shell prompt.
