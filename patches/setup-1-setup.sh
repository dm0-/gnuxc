#!/bin/bash
# This should have been run on first boot to configure system components that
# are difficult to handle cross-platform.  You probably shouldn't run it again.

export PATH=/usr/bin:/usr/sbin:/bin:/sbin
set -v

# Support local sockets (e.g. pipes).
settrans -acfgp /servers/socket/1 /hurd/pflocal

# Create useful devices.
(cd /dev && MAKEDEV -k com0 hd{0..3}{,s{1..4}} ptyp std tty{1..6} vcs)

# Make the Hurd console store a lot more scrollback lines.
settrans -acfgp /dev/vcs /hurd/console --lines=10000

# Write core files on crashes for debugging.
settrans -acfgp /servers/crash /hurd/crash --dump-core

# Use only pseudo-random devices for now, until there is entropy gathering.
ln -ns urandom /dev/random

# Prepare default input devices for running X.
ln -st /dev cons/kbd cons/mouse

# Support IPv4 sockets, statically assigned for a QEMU guest by default.
settrans -acfgp /servers/socket/2 /hurd/pfinet --interface=eth0 \
    --address=10.0.2.129 --gateway=10.0.2.2 --netmask=255.255.255.0

# Support a handy /proc filesystem.
settrans -acfgp /proc /hurd/procfs

# Make some memory-backed filesystems that get cleared on reboots.
settrans -acfgp /tmp \
    /hurd/tmpfs --mode=1777 --no-{exec,inherit-dir-group,suid} --writable 50%
cp -a /run /tmp/run.setup
settrans -acfgp /run \
    /hurd/tmpfs --mode=0755 --no-{exec,inherit-dir-group,suid} --writable 1M
cp -a /tmp/run.setup/* /run/

# Allow certain bits of vmstat, /proc/meminfo, etc. to work.
settrans -acfgp /servers/default-pager /hurd/proxy-defpager

# Create a default locale definition.
localedef -f UTF-8 -i en_US en_US.UTF-8

# Install the bootloader.
disk=$(grep -o 'hd[0-9]*' /proc/cmdline)
grub-install --themes=gnu /dev/${disk:-hd0}
LANG=en_US.UTF-8 grub-mkconfig -o /boot/grub/grub.cfg

# Initialize some caches.
gdk-pixbuf-query-loaders > \
    $(pkg-config --variable=gdk_pixbuf_binarydir gdk-pixbuf-2.0)/loaders.cache
update-mime-database /usr/share/mime

# Set up permissions for shared game state files.
chgrp -R games /var/games/*
chmod -R ug+rw,o-w /var/games/*

# Create a non-root user (with sudo for convenience).
echo 'gnu:x:1000:1000:GNU Hacker:/home/gnu:/bin/bash' >> /etc/passwd
echo 'gnu::0:0:-1:7:::' >> /etc/shadow
echo 'gnu:*:1000:' >> /etc/group
sed -i -e '/^\(games\|wheel\):/{s/[^:]$/&,/;s/$/gnu/;}' /etc/group
cp -a /etc/skel /home/gnu
chown -R gnu:gnu /home/gnu
chmod 750 /home/gnu

# Populate the root user's home directory with application settings.
cp -an /etc/skel/.[!.]* /root/

# Initialization is complete, so pick GNU Shepherd as the future init system.
test -e /usr/bin/shepherd && ln -fns ../usr/bin/shepherd /sbin/init ||
# Or, in case something weird is going on and Shepherd doesn't exist, use bash.
ln -fns ../bin/bash /sbin/init

# Change over to the new init system to pretend this was a normal system boot.
exec /sbin/init
