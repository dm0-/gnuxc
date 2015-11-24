# GNU OS Cross-Compiler - First Build

This document is intended to be a brief walkthrough of your first cross-build
of a GNU system.  It covers the one-time configuration of your environment, the
entire build procedure, some initial runtime instructions, and uninstallation.


## Preparation

**Install packages needed to follow this document.**  Using `ext2` as the root
file system, `fat32` for the EFI system partition, and `qemu` (with KVM, if
possible) for a virtual runtime environment will require the following tools.

    sudo dnf -y install dosfstools e2fsprogs qemu-system-x86

**Install build system dependencies.**  The main `GNUmakefile` and RPM build
commands call these external programs for their various operations.

    sudo dnf -y install \
        gcc-c++ guile libtool make \
        bzip2 gzip lzip tar xz-lzma-compat unzip \
        cvs git wget

**Abbreviate the virtual machine command.**  This alias starts `qemu` with a
virtual hardware configuration that is known to work with Hurd.  It will use
KVM, if it's available and running on `x86`.

    alias qemu-hurd="$(test -e /dev/kvm -a "$(uname -m)" = x86_64 &&
        echo -n qemu-kvm -enable-kvm -cpu host || echo -n qemu-system-i386
        echo '' -no-quit -nodefaults \
            -smp cores=1 -m 1G -vga qxl \
            -netdev user,id=eth0 -device rtl8139,netdev=eth0 \
            -device virtio-rng-pci )"
    sed -i -e '/^alias qemu-hurd=/d' ~/.bashrc
    alias qemu-hurd >> ~/.bashrc

**Abbreviate the build command.**  If you are going to use a working directory
separate from the source directory, use this alias to call the `make` system.
This alias is also where you can append tuning settings such as `tune=pentium`
or `exclude='hal icecat'` to omit projects.

    alias gmake="make -f ${SOURCE_DIR:-$PWD}/GNUmakefile"
    sed -i -e '/^alias gmake=/d' ~/.bashrc
    alias gmake >> ~/.bashrc

**Optionally, configure account groups.**  If you build the bundled Linux-libre
virtual machine and want its console to use consistent key bindings with the
Hurd system, add yourself to the `tty` group.  You can also remove the need for
`sudo` while working with loop devices by adding yourself to `disk`.  Remember
to log out after this for new groups to take effect.

    sudo usermod -a -G disk,tty "$USER"


## Sysroot and Cross-Tools

Before you can cross-compile the operating system software, you first need to
make the cross-compilers themselves.  These compilers, related tools, and
development files are packaged in RPMs for easy management on the build system.

**Install RPM development utilities.**  These tools are necessary to build and
install packages on the build system.

    sudo dnf -y install createrepo_c dnf-plugins-core rpmdevtools

**Set up an RPM build environment.**  This will create the `rpmbuild` directory
hierarchy and place links to the source files in the expected paths.

    rpmdev-setuptree
    ln -fst "$(rpm -E %_specdir)" "${SOURCE_DIR:-$PWD}"/specs/*
    ln -fst "$(rpm -E %_sourcedir)" "${SOURCE_DIR:-$PWD}"/patches/*

**Build and install everything needed to compile the OS.**  The job server from
this `make` command is shared with all of the `make` commands in the RPM build
scripts to maximize CPU core usage.  You'll want to make it run at least as
many parallel jobs as you have processor cores in your machine.  This command
will let the RPM build settings decide that number for you.

    guile --no-auto-compile "${SOURCE_DIR:-.}/setup-sysroot.scm" |
    make -f- $(rpm -E %_smp_mflags)

If you have GNU Make version 4 or later built with Guile support (which is
currently only in Rawhide), you can run this equivalent command instead.

    make -f "${SOURCE_DIR:-.}/setup-sysroot.scm" $(rpm -E %_smp_mflags)


## Target Disk

The operating system needs an available disk for its installation destination.
Choose one of the following two commands, depending on whether you want to
install to a virtual disk image or a dedicated physical disk (like a USB key or
SD card), respectively.  *The procedures in this document will overwrite any
preexisting data on the selected disk.*

**Allocate space for the disk image.**  The number at the end of this command
is the size in GiB, so this will create a file `gnu.img` of size 10 GiB.  This
is enough space for the full install, plus plenty of room for regular usage.

    dd bs=1G if=/dev/null of=${gnu_disk:=gnu.img} seek=10

**Prepare the physical storage device.**  Problems can arise later (e.g. when
installing the bootloader) if traces of earlier GPT formatting remain on the
device.  This will zero out the space before the first partition so there is no
trouble.  (Be sure to set the `gnu_disk` variable to the path of your device.)

    sudo dd bs=512 count=2048 if=/dev/zero of=${gnu_disk:?Set to a device.}

**Define the partition layout.**  This example layout will create two primary
partitions.  The first uses 100 MiB for an EFI system partition, so the disk
can be booted on EFI-only systems.  The second partition uses all the remaining
disk space for the operating system itself.

    esp_megabytes=100
    esp_offset=2048
    sector_size=512
    ext2_offset=$(( esp_megabytes * 1048576 / sector_size + esp_offset ))
    echo o \
        n p 1 $esp_offset $(( ext2_offset - 1 )) \
        n p 2 $ext2_offset '' \
        t 1 ef \
        t 2 63 \
        w | tr ' ' '\n' | sudo fdisk -b $sector_size $gnu_disk

**Create the ESP file system.**  It's just FAT32.

    loop_esp=$(sudo losetup --show --sizelimit $(( esp_megabytes * 1048576 )) \
        -fo $(( esp_offset * sector_size )) $gnu_disk)
    sudo mkfs.fat -F 32 -n GNU-ESP $loop_esp

**Create the `ext2` file system.**  Only a few feature-support flags are usable
on the file system, since they can make Linux write things to the disk that
Hurd won't be able to understand.

    loop=$(sudo losetup --show -fo $(( ext2_offset * sector_size )) $gnu_disk)
    sudo mke2fs -F -t ext2 -o hurd \
        -T hurd -b 4096 -I 128 \
        -O none,dir_index,ext_attr,sparse_super \
        -L GNU -m 0 $loop


## Operating System

### Downloads

**Install project dependencies.**  Most of these will already be installed if
you built the sysroot packages on the same machine.

    sudo dnf -y install \
        bc bison ed flex{,-devel} gperf groff intltool nasm texinfo yasm \
        {gnu-free-{mono,sans,serif},unifont}-fonts ImageMagick libicns-utils \
        help2man perl-ExtUtils-MakeMaker perl-gettext perl-podlators \
        {freetype,gdk-pixbuf2,gobject-introspection,guile,xorg-x11-proto}-devel

The `hal` project requires a few native static libraries.

    sudo dnf -y install {glib2,glibc,ncurses,zlib}-static

**Download and patch all the sources.**  The `prepare` target refers to having
a complete and patched source tree prepared to be built.  This `make` command
should not use (many) parallel jobs as a courtesy to the hosting servers.

    gmake prepare


### Building

**Compile everything.**  Every project that goes into the operating system is
built by the default `all` target.  You'll want to make it run at least as many
parallel jobs as you have processor cores in your machine.  This command will
let the RPM build settings decide that number for you.

    gmake $(rpm -E %_smp_mflags)

**Mount the target file system over the install root.**  Making your account
the owner allows installation without super user privileges.

    sudo mount -t ext2 \
        -o 'context="system_u:object_r:tmp_t:s0",x-mount.mkdir' \
        $loop gnu-root
    sudo chown -hR "$USER" gnu-root

Also mount the ESP at `/boot/efi` to install the EFI bootloader.

    mkdir -p gnu-root/boot/efi
    sudo mount -t vfat \
        -o "context=\"system_u:object_r:tmp_t:s0\",uid=$USER" \
        $loop_esp gnu-root/boot/efi

**Assemble the root file system.**  The `install` target respects the `DESTDIR`
variable, which by default is `gnu-root` in the current directory.  It will be
the root of the file system.  You probably don't want to run the installs with
parallel jobs, since the limiting factor will be disk I/O in many cases anyway.

    gmake install

**Unmount the EFI system partition.**  The disk is already EFI-bootable, and
Hurd won't need to modify the ESP at runtime.  It can be unmounted forever.

    sudo umount -d gnu-root/boot/efi

**Save copies of the boot files.**  Bootloaders require three files from the
installed system: the microkernel, a statically linked file system server, and
the dynamic linker.  Keep a copy of them outside the target file system.

    cp gnu-root/boot/gnumach gnumach
    cp gnu-root/hurd/ext2fs.static ext2fs
    cp gnu-root/lib/ld.so exec

**Correct file ownership.**  Since the installation was done without super user
privileges, the install root should have its files' owners recursively set to
`root`.  Linux's `chown` system call drops certain mode bits, so those must be
restored separately.

    find gnu-root -perm /7000 -printf 'chmod %m %p\n' > fix_suid.sh
    sudo chown -hR 0:0 gnu-root
    sudo sh -e fix_suid.sh && rm -f fix_suid.sh

**Unmount and verify the root file system.**

    sudo umount gnu-root && rmdir gnu-root
    sudo e2fsck -Dfy $loop
    sudo losetup -d $loop


### Native Initialization

**Boot your new system.**  One of the remaining steps is to install the disk's
bootloader, so the system first requires QEMU's built-in multiboot support.

    qemu-hurd $gnu_disk \
        -kernel gnumach \
        -append 'root=device:hd0s2 -f' \
        -initrd "$(echo \
            ext2fs \
                --device-master-port='${device-port}' \
                --exec-server-task='${exec-task}' \
                --host-priv-port='${host-port}' \
                --multiboot-command-line='${kernel-command-line}' \
                -T typed '${root}' '$(task-create)' '$(task-resume)' \
            ,exec \
                /hurd/exec '$(exec-task=task-create)' )"

Some points to note about this command are that it boots with a writable root
file system and gives the `-f` argument to skip the file system check.  This is
because the first boot will automatically run an initialization script to write
translators etc. to the disk, as well as to install the bootloader.  When this
script is finished, it will start GNU dmd as in a regular system boot.

When the initialization is complete, you should see a login prompt.  You can
now explore the system, but don't forget to try the bootloader.  To shut down,
run `sudo halt` after logging into the system with either the `root` or `gnu`
user (both with no password by default).

**Clean up files.**  With the bootloader installed, you can decide whether you
plan on using QEMU's multiboot options again to bypass it.  If not, clean up
the now-redundant boot files in the build directory.

    rm -f gnumach ext2fs exec


## Runtime

The system is ready to be started and used normally with this command.

    qemu-hurd $gnu_disk

### Using the GNU System

**Using GNU GRUB.**  When directly booting the disk as above, a graphical GRUB
menu will be displayed with a few options.  A GRUB command line environment can
be activated by pressing `c`, and menu entries can be customized or inspected
by highlighting one and pressing `e`.

The first/default menu item will boot Hurd in a standard fashion.  It uses GNU
dmd to start system services, including the Hurd console client.

To rescue or debug the OS, the next two bootloader options perform a minimal
boot-to-shell with a writable and read-only root file system, respectively.

The last option offers to start a virtual system.  It is intended to be used
when booting the OS on physical hardware that is unsupported by Mach and Hurd.
This option is effectively used automatically when EFI-booting the disk.  It
boots Linux-libre, which runs the Hurd-based OS in QEMU for compatibility.

**Using the GNU Hurd console.**  After selecting the default boot option, the
system should display a login prompt.  Two usable accounts are provided, `root`
and `gnu`.  The `gnu` account is a regular user account with `sudo` abilities.

There are six virtual terminals by default.  With `Alt+Left` or `Alt+Right` you
can switch to an adjacent terminal, and `Alt+n` will jump to the terminal
numbered *n*.

Pressing `Ctrl+Alt+Backspace` will terminate the Hurd console client and return
to the GNU Mach console.  It is preferable to use the `console` service to stop
and start the Hurd console, however.  This command will use GNU dmd to return
to the more basic GNU Mach console.

    sudo deco stop console

Finally, a graphical desktop can be launched from the Hurd console.  Run the
following while logged into the `gnu` account on one of the virtual terminals.

    startx

If instead of directly starting a user's desktop environment, you want to show
a graphical login screen, start the XDM service.

    sudo deco start xdm

**Using GNU WindowMaker.**  The X environment is provided by `wmaker` by
default.  Applications can be accessed easily from its right-click menu, as can
adding new workspaces, etc.  Pressing `Alt+F2` will display a window prompting
for a command to execute.

The default key configuration is fairly consistent with the Hurd console.  Use
`Alt+Left`, `Alt+Right`, and `Alt+n` to switch workspaces again.  X can be
terminated with `Ctrl+Alt+Backspace` to return to the Hurd console.


### Tying up Loose Ends

**Configure daemons to start on boot.**  The last line of `/etc/dmdconf.scm`
contains a space-separated list of services (defined in `/etc/dmd.d`) to start
automatically.  The provided configuration starts the Hurd console client and
login programs by default.  Change `console` to `xdm` to boot to a graphical
login prompt instead of the console, if desired.  You will probably want to add
other services to start at boot, such as `cron` or `syslog`.  Use the `deco`
command to start other services at runtime, e.g. `sudo deco start syslog`.

**Preempt the cron jobs.**  There are some cache databases being regenerated at
random times daily.  Run the cron commands manually if you don't want to wait
for their scheduled times.  The following will list each system cron job.

    cat /etc/cron.d/*

**Install the packages that were too broken for cross-compilation.**  Log into
the `root` account, which has an alias `gmake` to build and install packages.

Install `perl` and its assorted modules.  They are required to run certain
utilities such as `help2man` and `intltool`.

    gmake install-perl
    gmake install-perl-gettext install-perl-XML-Parser

Emacs still needs to be installed properly since its binary is generated at
runtime.  (Without running this step, the `emacs` command launches Zile.)

    gmake install-emacs


## Uninstallation

### Preparing to Rebuild from Scratch

If your goal is to reset the build environment in order to start fresh, there
are two areas to clean.

**Remove the cross-tools and sysroot.**  Since everything was installed from
RPMs, a `dnf remove` command will handle the obvious parts.  The RPM repository
also must be removed so that no packages are skipped during the next rebuild.

    sudo dnf -y remove 'gnuxc-*'
    rm -fr "$(rpm -E %_rpmdir)/repodata"
    rm -f {"$(rpm -E %_rpmdir)"{/*,},"$(rpm -E %_srcrpmdir)"}/gnuxc-*.rpm

**Remove the cross-compiled source directories.**  If you used a dedicated
working directory for running the `gmake` commands, simply delete it.  If you
have any valuable files in the working directory, a `clean` target is available
to remove all of the package source trees individually.

    gmake clean

**Begin rebuilding.**  From this point, you can start following this document
from the beginning to build a fresh OS image.  Any remaining files will either
be unused or overwritten with new data.


### Uninstalling Entirely

If your goal is to wipe out everything in a complete uninstall, there are a few
more steps in addition to the previous section.

**Undo configurations.**  The bash aliases can be removed.

    sed -i -e '/^alias \(gmake\|qemu-hurd\)=/d' ~/.bashrc

**Clean the RPM build tree.**  There are source archives and patch links under
`%_sourcedir` and spec links under `%_specdir`.  This will delete the relevant
sources and specs individually.

    rpmbuild --rmsource --rmspec "$(rpm -E %_specdir)"/gnuxc-*.spec

Alternatively, if you haven't been building any other important RPMs, you could
just wipe out the entire `rpmbuild` directory.

    rm -fr "$(rpm -E %_topdir)"

**Delete this directory.**  The last step for a complete uninstall is to remove
this project itself.  Once it's gone, everything installed here (except distro
RPMs from build dependencies) should be purged from your build system.
