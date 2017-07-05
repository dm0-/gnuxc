#!/bin/ash -ev
abort() { echo 'Init failed!' 1>&2 ; exec ash -i ; } ; trap abort EXIT

# Load the keymap before anything fails and starts an interactive shell.
[ ! -s /usr/share/kbd/emacs2 ] || loadkmap < /usr/share/kbd/emacs2

# Check early if the user is holding Control to configure the VM.
ctrl_is_down && config_prompt=1 || config_prompt=

# Mount the file system interfaces into the kernel.
mount -t devtmpfs devtmpfs /dev
mount -t proc proc /proc
mount -t sysfs sysfs /sys

# Spawn a host shell on tty4 that restarts on exit.
while : ; do ash -i || : ; done 3<>/dev/tty4 0<&3 1>&3 2>&3 3>&- &

# Define or detect default parameters for the virtual machine.
disk=   # Choose a disk device to boot virtually, or blank to search for it.
iface=  # Choose the host network interface to use, or blank to make a guess.
cores=1 # Choose how many CPU cores to use in the virtual machine.
[ -e /dev/kvm ] && kvm=1   || kvm=   # Enable acceleration, given KVM support.
[ -e /dev/fb0 ] && fbdev=1 || fbdev= # Enable graphics, given a framebuffer.
while read field value extra ; do # Give 3/4 of the system's RAM to the VM.
        [ "$field" = 'MemTotal:' ] && memory=$value && break || continue
done < /proc/meminfo
[ "${memory:-0}" -gt 349525 ] && memory=$(( memory * 3 / 4096 )) || memory=256

# XXX: At least 3.5 GiB of RAM will make gnumach explode.  Limit it to 3 GiB.
[ "${memory:-0}" -le 3072 ] || memory=3072

# Allow the user to override the defaults above with the boot command.
read args < /proc/cmdline ; args=" $args "
[ "$args" = "${args#* gnuxc.ask }" ] || config_prompt=1
opt=${args##* gnuxc.boot=} ; [ "$opt" = "$args" ] && opt= || opt=${opt%% *}
${opt:+eval disk=$opt}
opt=${args##* gnuxc.cores=} ; [ "$opt" = "$args" ] && opt= || opt=${opt%% *}
${opt:+eval cores=$opt}
opt=${args##* gnuxc.iface=} ; [ "$opt" = "$args" ] && opt= || opt=${opt%% *}
${opt:+eval iface=$opt}
opt=${args##* gnuxc.kvm=} ; [ "$opt" = "$args" ] && opt= || opt=${opt%% *}
${opt:+eval [ "$opt" = 0 -o "$opt" = no ] && kvm= || kvm=1}
opt=${args##* gnuxc.fbdev=} ; [ "$opt" = "$args" ] && opt= || opt=${opt%% *}
${opt:+eval [ "$opt" = 0 -o "$opt" = no ] && fbdev= || fbdev=1}
opt=${args##* gnuxc.memory=} ; [ "$opt" = "$args" ] && opt= || opt=${opt%% *}
${opt:+eval memory=$opt}
opt=${args##* gnuxc.ssid=} ; [ "$opt" = "$args" ] && opt= || opt=${opt%% *}
${opt:+eval ssid=$opt}
opt=${args##* gnuxc.pass=} ; [ "$opt" = "$args" ] && opt= || opt=${opt%% *}
${opt:+eval pass=$opt}

# Wait for the specified network interface (or default eth0/wlan0) to appear.
[ -n "$ssid" ] && tface=wlan0 || tface=eth0 ; [ -z "$iface" ] || tface=$iface
for x in '' 1 2 3 4 5 ; do
        ${x:+eval echo 'Waiting for network interfaces...' && sleep 1}
        [ -e "/sys/class/net/$tface/device" ] || continue
        iface=$tface ; break
done

# If not given an interface and defaults are missing, use the first one found.
if [ -z "$iface" ] ; then
        for device in /sys/class/net/* ; do
                [ -n "$ssid" -a -e "$device/wireless" ] ||
                [ -z "$ssid" -a -e "$device/device" ] ||
                continue ; iface=${device##*/} ; break
        done
fi

# Wait for the user's chosen disk to appear, or try to find the correct one.
for x in '' '' 1 2 3 4 5 ; do
        ${x:+eval echo 'Waiting for disks...' && sleep 1}
        [ -e "$disk" ] && break || [ -z "$disk" ] || continue
        disk=$(findfs LABEL=GNUXC || findfs LABEL=GNUXCESP) &&
        disk=${disk%%[0-9]*} || disk=
done

# Allow manually setting all VM parameters, if the user requested it.
! ctrl_is_down || config_prompt=1 # Check the Control key again for slow users.
set +v # Hide script debugging for a readable configuration menu.
wifi=1
a=$(echo -en '\e[31m')          # Begin the prompt wrapper
b=$(echo -en ' \e[0m\e[31;1m[') # Begin the default value wrapper
c=$(echo -en ']\e[0m\e[31m')    # End the default value wrapper
d=$(echo -en '?\e[0m ')         # End the prompt wrapper
[ -z "$config_prompt" ] || until [ -n "$confirmed" ] ; do
        echo -e '\nChoose your VM settings.  Press Enter to use the default.'
        read -rp "${a}Boot which disk device${disk:+$b$disk$c}$d" opt
        [ -z "$opt" ] || disk=$opt
        [ -n "$kvm" ] && kvm=yes || kvm=no
        read -rp "${a}Use KVM acceleration$b$kvm$c$d" opt
        [ -z "$opt" ] || kvm=$opt
        [ "${kvm:-0}" = 0 -o "$kvm" = no ] && kvm= || kvm=1
        read -rp "${a}Provide how many CPU cores${cores:+$b$cores$c}$d" opt
        [ -z "$opt" ] || cores=$opt
        read -rp "${a}Provide how many MiB of RAM${memory:+$b$memory$c}$d" opt
        [ -z "$opt" ] || memory=$opt
        [ -n "$fbdev" ] && fbdev=yes || fbdev=no
        read -rp "${a}Use a graphical display$b$fbdev$c$d" opt
        [ -z "$opt" ] || fbdev=$opt
        [ "${fbdev:-0}" = 0 -o "$fbdev" = no ] && fbdev= || fbdev=1
        read -rp "${a}Use which network interface${iface:+$b$iface$c}$d" opt
        [ -z "$opt" ] || iface=$opt
        [ -e "/sys/class/net/${iface:- }/wireless" ] && wifi=yes || wifi=no
        read -rp "${a}Use this network interface for wireless$b$wifi$c$d" opt
        [ -z "$opt" ] || wifi=$opt
        [ "${wifi:-0}" = 0 -o "$wifi" = no ] && wifi= || wifi=1
        if [ -n "$wifi" ] ; then
                read -rp "${a}Connect to what SSID${ssid:+$b$ssid$c}$d" opt
                [ -z "$opt" ] || ssid=$opt
                read -rsp "${a}Use what password$d" pass && echo
        fi
        echo
        echo "Virtually booting disk: $disk"
        echo -n 'KVM acceleration:       '
        [ -n "$kvm" ] && echo enabled || echo disabled
        echo "Virtual CPU cores:      $cores"
        echo "Virtual RAM size:       $memory MiB"
        echo -n 'Virtual display:        '
        [ -n "$fbdev" ] && echo full graphics || echo text only
        echo "Host network interface: $iface"
        echo -n 'Interface type:         '
        [ -n "$wifi" ] && echo wireless || echo generic
        [ -z "$wifi" ] || echo "Wireless SSID:          $ssid"
        [ -z "$wifi" ] || echo "Wireless password:      ${pass//?/.}"
        echo
        read -rp "${a}Is this correct${b}yes$c$d" opt
        [ "${opt:-1}" = 0 -o "$opt" = no ] && confirmed= || confirmed=1
done
[ -n "$fbdev" ] && display=fbdev || display=curses
[ -n "$wifi" ] || ssid=
set -v

# Configure the network via DHCP, if it's available.
if [ -n "$iface" -a -e "/sys/class/net/$iface/device" ] ; then
        ifconfig "$iface" up
        if [ -n "$ssid" ] ; then
                echo -e "network={\n\tssid=\"$ssid\"" > /etc/wpa.conf
                [ -z "$pass" ] && echo -e '\tkey_mgmt=NONE' >> /etc/wpa.conf ||
                echo -e "\tkey_mgmt=WPA-PSK\n\tpsk=\"$pass\"" >> /etc/wpa.conf
                echo '}' >> /etc/wpa.conf
                wpa_supplicant -B -D wext -i "$iface" -c /etc/wpa.conf
        fi
        udhcpc -i "$iface" -nt 5 || :
fi

# Run the virtual machine.
qemu-system-x86_64 -nodefaults \
    -monitor /dev/tty2 -serial /dev/tty3 \
    ${kvm:+-machine accel=kvm -enable-kvm -cpu host} \
    -smp cores="${cores:-1}" -m "${memory:-256}"M \
    -display "${display:=curses}" -vga std -soundhw ac97 \
    -netdev user,id=eth0 -device pcnet,netdev=eth0 \
    -device virtio-rng-pci \
    -drive media=disk,if=ide,format=raw,file="${disk:-/dev/sda}" \
    -smbios type=1,manufacturer=gnuxc,product="hal-$display"

# Shut down the physical machine along with the virtual machine.
exec poweroff -f
