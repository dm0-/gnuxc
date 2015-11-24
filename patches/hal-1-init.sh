#!/bin/ash -ev
abort() { echo 'Init failed!' 1>&2 ; exec ash ; } ; trap abort EXIT

# Load the keymap before anything fails and starts an interactive shell.
[ ! -s /usr/share/kbd/emacs2 ] || loadkmap < /usr/share/kbd/emacs2

# Mount the filesystem interfaces into the kernel, and scan for devices.
mount -t devtmpfs devtmpfs /dev
mount -t proc proc /proc
mount -t sysfs sysfs /sys
mdev -s

# Choose a disk device to boot virtually, or blank to search for it.
disk=

# Choose a network interface to try by default, or blank to disable networking.
iface=eth0

# Enable KVM if the kernel appears to support it on this system.
[ ! -e /dev/kvm ] || kvm=1

# Determine if there is a framebuffer device for displaying graphics.
[ ! -e /dev/fb0 ] || display=fbdev

# Calculate half the system's RAM (or at least 256 megabytes) to give the VM.
while read field value extra ; do
        [ "$field" = 'MemTotal:' ] && memory=$value && break || continue
done < /proc/meminfo
[ "${memory:-0}" -gt 262144 ] && memory=$(( memory / 2048 )) || memory=256

# Allow the user to override the defaults above.
read args < /proc/cmdline
opt=${args##* gnuxc.boot=} ; [ "$opt" = "$args" ] && opt= || opt=${opt%% *}
${opt:+eval disk=$opt}
opt=${args##* gnuxc.cores=} ; [ "$opt" = "$args" ] && opt= || opt=${opt%% *}
${opt:+eval cores=$opt}
opt=${args##* gnuxc.iface=} ; [ "$opt" = "$args" ] && opt= || opt=${opt%% *}
${opt:+eval [ "$opt" = 0 -o "$opt" = false ] && iface= || iface=$opt}
opt=${args##* gnuxc.kvm=} ; [ "$opt" = "$args" ] && opt= || opt=${opt%% *}
${opt:+eval [ "$opt" = 0 -o "$opt" = false ] && kvm= || kvm=1}
opt=${args##* gnuxc.fbdev=} ; [ "$opt" = "$args" ] && opt= || opt=${opt%% *}
${opt:+eval [ "$opt" = 0 -o "$opt" = false ] && display= || display=fbdev}
opt=${args##* gnuxc.memory=} ; [ "$opt" = "$args" ] && opt= || opt=${opt%% *}
${opt:+eval memory=$opt}

# Configure the network via DHCP, if it's available.
for x in '' 1 2 3 4 5 ; do
        ${x:+eval echo 'Waiting for network interfaces...' && sleep 1}
        [ -n "$iface" -a ! -e "/sys/class/net/$iface/device" ] || break
done
${iface:+eval ifconfig "$iface" up && udhcpc -i "$iface" -nt 3 || :}

# Wait for the user's chosen disk to appear, or try to find the correct one.
for x in '' '' 1 2 3 4 5 ; do
        ${x:+eval echo 'Waiting for disks...' && sleep 1}
        [ -e "$disk" ] && break || [ -z "$disk" ] || continue
        disk=$(findfs LABEL=GNU) && disk=${disk%%[0-9]*} || disk=
done

# Run the virtual machine.
qemu-system-x86_64 -nodefaults \
    ${kvm:+-machine accel=kvm -enable-kvm -cpu host} \
    -smp cores="${cores:-1}" -m "${memory:-256}"M \
    -display ${display:=curses} -vga std \
    -netdev user,id=eth0 -device rtl8139,netdev=eth0 \
    -device virtio-rng-pci \
    -drive media=disk,if=ide,format=raw,file="${disk:-/dev/sda}" \
    -smbios type=1,manufacturer=gnuxc,product=hal-$display

# Shut down the physical machine along with the virtual machine.
exec poweroff -f
