#!/bin/bash
# Run this to configure files that can't be handled cross-platform.

test ${SHLVL:-0} -ne 2 &&
echo -e "This script must be run with the command:\\nsource $0" 2>&1 &&
exit 1

export PATH=/usr/bin:/usr/sbin:/bin:/sbin
set -v

# Support local sockets (e.g. pipes).
settrans -afgp /servers/socket/1 /hurd/pflocal

# Create useful devices.
pushd /dev
MAKEDEV hd{0..3}{,s{1..4}} ptyp std tty{1..6} vcs
popd

# Prepare default input devices for running X.
ln -s cons/kbd /dev/kbd
ln -s cons/mouse /dev/mouse

# Add a horribly broken security workaround until virtio-rng is ready.
ln -s zero /dev/random
ln -s zero /dev/urandom

# Support IPv4 sockets.
settrans -afgp /servers/socket/2 /hurd/pfinet --interface=eth0 \
    --address=10.0.2.129 --gateway=10.0.2.2 --netmask=255.255.255.0

# Support a handy /proc filesystem.
settrans -afgp /proc /hurd/procfs

# Install the bootloader.
disk=$(grep -o 'hd[0-9]*' /proc/cmdline)
grub-install --themes=active /dev/${disk:-hd0}
ln -s 'en@quot.mo' /boot/grub/locale/en.mo

# Create a default locale definition.
localedef -f UTF-8 -i en_US en_US.UTF-8

# Initialize the man page database.
mandb

# Create a non-root user.
echo 'gnu:x:1000:1000:GNU Hacker:/home/gnu:/bin/bash' >> /etc/passwd
echo 'gnu::0:0:-1:7:::' >> /etc/shadow
echo 'gnu:*:1000:' >> /etc/group
cp -a /etc/skel /home/gnu
chown -R gnu:gnu /home/gnu
chmod 750 /home/gnu

# Hide this file, and return to the runsystem script to start a login prompt.
exec mv /root/setup.sh /root/.local/share/
