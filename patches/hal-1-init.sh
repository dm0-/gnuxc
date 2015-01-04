#!/bin/ash -ev
abort() { echo 'Init failed!' 1>&2 ; exec ash ; } ; trap abort EXIT

# Load the keymap before anything fails and starts an interactive shell.
[ ! -s /usr/share/kbd/emacs2 ] || loadkmap < /usr/share/kbd/emacs2

# Mount the filesystem interfaces into the kernel.
mount -t devtmpfs devtmpfs /dev
mount -t proc proc /proc && read args < /proc/cmdline
mount -t sysfs sysfs /sys

# Scan for devices.
mdev -s

# Determine which network interface to start, and give it a few seconds.
iface=eth0
opt=${args##* gnuxc.iface=} ; [ "$opt" = "$args" ] && opt= || opt=${opt%% *}
${opt:+eval [ "$opt" = 0 -o "$opt" = false ] && iface= || iface=$opt}
for x in '' 1 2 3 4 5 ; do
        ${x:+eval echo 'Waiting for network interfaces...' && sleep 1}
        [ -n "$iface" -a ! -e "/sys/class/net/$iface" ] || break
done

# Start the network via DHCP, if it's available.
${iface:+eval ifconfig "$iface" up && udhcpc -i "$iface" -nt 3 || :}

# Determine whether to use KVM.
[ ! -e /dev/kvm ] || kvm=1
opt=${args##* gnuxc.kvm=} ; [ "$opt" = "$args" ] && opt= || opt=${opt%% *}
${opt:+eval [ "$opt" = 0 -o "$opt" = false ] && kvm= || kvm=1}

# Determine whether to abandon the framebuffer for text mode.
[ ! -e /dev/fb0 ] || fbdev=fbdev
opt=${args##* gnuxc.fbdev=} ; [ "$opt" = "$args" ] && opt= || opt=${opt%% *}
${opt:+eval [ "$opt" = 0 -o "$opt" = false ] && fbdev= || fbdev=fbdev}

# Determine how many megabytes of memory to use: half the available by default.
memory=$(free -k || echo 0);memory=$(echo ${memory#*Mem:});memory=${memory%% *}
[ "$memory" -gt 262144 ] && memory=$(( memory / 2048 )) || memory=128
opt=${args##* gnuxc.memory=} ; [ "$opt" = "$args" ] && opt= || opt=${opt%% *}
${opt:+eval memory=$opt}

# Determine which device to boot, and give it a few seconds again.
opt=${args##* gnuxc.disk=} ; [ "$opt" = "$args" ] && opt= || opt=${opt%% *}
${opt:+eval disk=$opt}
for x in '' '' 1 2 3 4 5 ; do
        ${x:+eval echo 'Waiting for disks...' && sleep 1}
        [ -e "$disk" ] && break || [ -z "$disk" ] || continue
        disk=$(findfs LABEL=GNU) && disk=${disk%%[0-9]*} || disk=
done

# Run the virtual machine.
qemu-system-x86_64 -nodefaults \
    ${kvm:+-machine accel=kvm -enable-kvm -cpu host} -smp cores=1 \
    -m "${memory:-128}"M \
    -display ${fbdev:-curses} -vga std \
    -netdev user,id=eth0 -device rtl8139,netdev=eth0 \
    -device virtio-rng-pci \
    -hda "${disk:-/dev/sda}" \
    -smbios type=1,manufacturer=gnuxc,product=hal

# Shut down the physical machine along with the virtual machine.
exec poweroff -f
