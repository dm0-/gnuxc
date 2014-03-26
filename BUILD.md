# GNU OS Cross-Compiler - First Build

This document is intended to be a brief walkthrough of your first cross-build
of a GNU system.  It covers the one-time configuration of your environment, the
entire build procedure, some initial runtime instructions, and uninstallation.



## Preparation

### Dependency Installation

**Install packages needed to follow this document.**  The choice of `ext2` as
the root filesystem and `qemu` (with KVM, if possible) for a virtual runtime
environment will require the following tools.

    sudo yum -y install e2fsprogs qemu-system-x86

**Install `make` system dependencies.**  The `make` file calls some external
programs for its various operations.

    sudo yum -y install \
        gcc-c++ libtool make \
        bzip2 gzip lzip tar xz-lzma-compat \
        cvs git wget

**Install project dependencies.**  This is the list that won't be automatically
installed by the sysroot RPM build dependencies.

    sudo yum -y install \
        gnu-free-{mono,sans,serif}-fonts ImageMagick \
        help2man perl-gettext perl-podlators \
        freetype-devel gperf groff intltool nasm ncurses-devel

**Install RPM development tools.**  These packages are going to be necessary to
build and maintain the cross-compiler tools and sysroot.

    sudo yum -y install createrepo redhat-rpm-config rpmdevtools yum-utils


### Shell Shortcuts

**Abbreviate the virtual machine command.**  This alias starts `qemu` with a
virtual hardware configuration that is known to work with Hurd.  It will use
KVM, if it's available and running on `x86`.

    alias qemu-hurd="$(test -e /dev/kvm -a "$(uname -m)" = x86_64 &&
        echo -n qemu-kvm -enable-kvm -cpu host || echo -n qemu-system-i386
        echo '' -display sdl -ctrl-grab -no-reboot -no-quit -nodefaults \
            -smp cores=1 -m 1G -vga std \
            -net nic,model=rtl8139 -net user \
            -device virtio-rng-pci )"
    sed -i -e '/^alias qemu-hurd=/d' ~/.bashrc
    alias qemu-hurd >> ~/.bashrc

**Abbreviate the build command.**  If you are going to use a working directory
separate from the source directory, use this alias to call the `make` system.
It is unnecessary when building in the same directory as the `make` files.

    alias gmake="make -f ${SOURCE_DIR:-$PWD}/GNUmakefile"
    sed -i -e '/^alias gmake=/d' ~/.bashrc
    alias gmake >> ~/.bashrc


### RPM Build/Repo Setup

**Set up an RPM build environment.**  This will create the `rpmbuild` directory
hierarchy and place links to the cross-compiler files in their standard paths.

    rpmdev-setuptree
    ln -fs "${SOURCE_DIR:-$PWD}"/specs/* "$(rpm -E %_specdir)/"
    ln -fs "${SOURCE_DIR:-$PWD}"/patches/* "$(rpm -E %_sourcedir)/"

**Create source archives for Hurd projects.**  The RPMs are built from project
tar files, but the Hurd projects are taken from a git clone.  This will prepare
distribution-ready archives from a specific commit for each Hurd project.

    gmake {clean,dist}-{glibc,gnumach,hurd,libpthread,mig}
    mv -f {glibc,gnumach,hurd,libpthread,mig}-*.tar.xz "$(rpm -E %_sourcedir)/"

**Define a package repository.**  The locally-built packages will be installed
with `yum` to handle dependencies easily.  This will add a disabled-by-default
repository for installing directly from `rpmbuild`.

    repo=rpmbuild
    rpmdir=$(rpm -E %_rpmdir)
    sudo tee "/etc/yum.repos.d/$repo.repo" << EOF 1>/dev/null
    [$repo]
    name=Local Custom Packages
    baseurl=file://$rpmdir
    keepcache=0
    enabled=0
    gpgcheck=0
    EOF
    createrepo "$rpmdir"



## Building

### Sysroot and Cross-Tools

**Run the included script to bootstrap the Hurd environment.**  The script will
build and install every RPM (one at a time), so this step will probably be the
most time-consuming part of this entire document.  You can continue along while
it builds, but wait for it to finish before you run the main compilation step.

    bash "${SOURCE_DIR:-.}/setup-sysroot.sh"


### Disk Image

**Allocate space for the disk image.**  The number at the end of this command
is the size in MiB, so this will create a file `gnu.img` of size 10 GiB.  This
is enough space for the full install, plus plenty of room for a playground.

    dd bs=1M if=/dev/null of=gnu.img seek=10240

**Define the partition layout.**  This example layout will simply create one
primary partition spanning the entire disk and set up a loop device at the
partition's offset.

    sector=2048
    size=512
    echo -e "o\nn\np\n1\n$sector\n\nw" | fdisk -b $size gnu.img
    loop=$(sudo losetup --find --offset $(( sector * size )) --show gnu.img)

**Create the filesystem.**  Only a few feature-support flags are usable on the
filesystem, since they can make Linux write things to the disk that Hurd won't
be able to understand.

    sudo mke2fs -t ext2 -o hurd \
        -T hurd -b 4096 -I 128 \
        -O none,dir_index,ext_attr,sparse_super \
        -L GNU -m 0 $loop


### Software

**Download and patch all the sources.**  The `prepare` target refers to having
a complete and patched source tree prepared to be built.  This `make` command
should not use parallel jobs as a courtesy to the download mirrors.

    gmake prepare

**Build everything.**  Every project that goes into the operating system is
built by the default `all` target.  You'll want to make it run at least as many
parallel jobs as you have processor cores in your machine.  This command will
let the RPM build settings decide that number for you.

    gmake $(rpm -E %_smp_mflags)

**Mount the target filesystem over the install root.**  Making your account the
owner allows installation without superuser privileges.

    sudo mount -t ext2 \
        -o 'context="system_u:object_r:tmp_t:s0",x-mount.mkdir' \
        $loop gnu-root
    sudo chown -hR "$USER" gnu-root

**Assemble the root filesystem.**  The `install` target respects the `DESTDIR`
variable, which by default is `gnu-root` in the current directory.  It will be
the root of the filesystem.  You probably don't want to run the installs with
parallel jobs, since the limiting factor will be disk I/O in most cases anyway.

    gmake install

**Save copies of the boot files.**  Bootloaders require three files from the
installed system: the microkernel, a statically linked filesystem server, and
the dynamic linker.  Keep a copy of them outside the disk image.

    cp gnu-root/boot/gnumach gnumach
    cp gnu-root/hurd/ext2fs.static ext2fs
    cp gnu-root/lib/ld.so exec

**Close the disk image.**  This section *should* be no more than a `chown` and
`umount -d gnu-root`, but Linux's behavior requires some workarounds.  Run the
following to generate scripts to fix the issues.

    find gnu-root \
        -fprintf fix_trans.txt 'sif /%P translator 0\n' \
        -perm /7000 -fprintf fix_suid.sh 'chmod %m %p\n'

Recursively set the installed files' owner to `root`.  Linux's `chown` system
call drops certain mode bits, so those must be restored.

    sudo chown -hR 0:0 gnu-root
    sudo sh -e fix_suid.sh && rm -f fix_suid.sh

The filesystem will now have to be modified offline.  Unmount it.

    sudo umount gnu-root && rmdir gnu-root

Linux writes its own `version` in place of Hurd's `translator` field, despite
the filesystem's OS setting.  Zero every file's translator value, verify the
filesystem, then detach the loop device.

    sudo debugfs -wf fix_trans.txt $loop && rm -f fix_trans.txt
    sudo e2fsck -Dfy $loop
    sudo losetup -d $loop



## Runtime

### Initialization

**Boot your new system.**  One of the remaining steps is to install the disk's
bootloader, so the system first requires `qemu`'s built-in multiboot support.

    qemu-hurd gnu.img \
        -kernel gnumach \
        -append 'root=device:hd0s1 -s' \
        -initrd "$(echo \
            ext2fs \
                --device-master-port='${device-port}' \
                --exec-server-task='${exec-task}' \
                --host-priv-port='${host-port}' \
                --multiboot-command-line='${kernel-command-line}' \
                -T typed '${root}' '$(task-create)' '$(task-resume)' \
            ,exec \
                /hurd/exec '$(exec-task=task-create)' )"

**Complete the installation.**  The virtual system should have booted into a
(very) limited `root` shell.  You might be tempted to poke around the system at
this point.  Don't.  Nothing will work.  Instead, source the initialization
script immediately.

    . /root/setup.sh

When the script ends, you will see a login prompt.  You can explore now, but
don't forget to try the bootloader.  Use the following (starting from the login
prompt) to shutdown, so the system can later be started in its natural state.

    login root
    reboot

**Clean up files.**  With the bootloader installed, you can decide whether you
plan on using `qemu`'s multiboot options again to bypass it.  If not, clean up
the now-redundant boot files.

    rm -f gnumach ext2fs exec


### Using the GNU System

The system is ready to be started and used normally with this command.

    qemu-hurd gnu.img

**Using GNU GRUB.**  When directly booting the disk image as above, GRUB will
be started in a graphical menu with a sample configuration file and theme.

The first/default menu item will boot Hurd in a standard fashion.  The second
option in the sample configuration performs a more minimal boot, and the final
option starts with a read-only filesystem.  Those last two are for debugging.

A GRUB command-line environment can be activated by pressing `c`, and menu
entries can be customized by highlighting one and pressing `e`.

**Using the GNU Mach console.**  After using the default boot option, the
system should reach a login prompt.  Two usable accounts are provided, `root`
and `gnu`.  The `gnu` account is a regular unprivileged user account.  They can
be used with the `login` command (e.g. `login gnu`).

This is a lower-level environment that does not take advantage of features from
the Hurd console server.  You will probably want to run the following, starting
from the login prompt.

    login root
    start-console

**Using the GNU Hurd console.**  The `start-console` alias (defined in the file
`/root/.bashrc`) launches a more flexible environment.  Many Unicode features
and character sets are supported.  The default fonts are in `/usr/share/hurd`.

There are six virtual terminals by default.  With `Alt+Left` or `Alt+Right` you
can switch to an adjacent terminal, and `Alt+`*n* will jump to the terminal
numbered *n*.

Pressing `Ctrl+Alt+Backspace` will exit this console and return to the previous
level.  Running `start-console` again will resume.

There is one more environment to reach.  Run the following starting from the
login prompt on one of the virtual terminals.

    login gnu
    startx

**Using GNU WindowMaker.**  The automatically-started X environment is `wmaker`
by default.  Applications can be accessed easily from its right-click menu, as
can adding new workspaces, etc.

The default key configuration is fairly consistent with the Hurd console.  Use
`Alt+Left`, `Alt+Right`, and `Alt+`*n* to switch workspaces.  X can be
terminated with `Ctrl+Alt+Backspace` to return to the Hurd console.


### Tying up Loose Ends

**Initialize a random seed for SSH.**  For each user that will run the SSH
client, create a seed file.

    lsh-make-seed

**Install the packages that were too broken for cross-compilation.**  It is
recommended to set up a dedicated directory for project source files.

    mkdir ~/wd && cd ~/wd

First, install `perl` and its `Locale::gettext` module.  This is required for
`help2man` to run, for example.

    gmake install-perl
    gmake install-perl-gettext

Optionally, `git` can be rebuilt now with Perl support.

    gmake install-git

A proper `emacs` installation is still required.  (Previously, `zile` was used
as the default editor.)

    gmake install-emacs



## Uninstallation and Cleaning

### Preparing to Rebuild from Scratch

If your goal is to reset the build environment in order to start fresh, there
are two areas to clean.

**Remove the cross-tools and sysroot.**  Since everything was installed from
RPMs, a `yum remove` command will handle the obvious parts.  The RPM repository
also must be deleted or moved so that bootstrapping steps aren't skipped during
the next rebuild.

    sudo yum -y remove 'gnuxc-*'
    rm -fr "$(rpm -E %_rpmdir)/repodata"
    rm -f "$(rpm -E %_rpmdir)"/*/gnuxc-*.rpm

**Remove the cross-compiled source directories.**  If you used a dedicated
working directory for running the `gmake` commands, simply delete it.  The only
file worth saving in there may be `gnu.img`, the standalone disk image.

If you have other valuable files in the working directory, a `clean` target is
available to remove all of the package source trees individually.

    gmake clean

**Begin rebuilding.**  From this point, you can start following this document
from the beginning to build a fresh OS image.  Any remaining files will either
be unused or overwritten with new data.


### Uninstalling Entirely

If your goal is to wipe out everything in a complete uninstall, there are a few
more steps in addition to the previous section.

**Undo configurations.**  The local package repository and aliases need to go.

    sudo rm -f "/etc/yum.repos.d/${repo:-rpmbuild}.repo"
    sed -i -e '/^alias \(gmake\|qemu-hurd\)=/d' ~/.bashrc

**Clean the RPM build tree.**  There are source archives and patch links under
`%_sourcedir`, spec links under `%_specdir`, and SRPMs under `%_srcrpmdir`.

    rpmbuild --rmsource --rmspec "$(rpm -E %_specdir)"/gnuxc-*.spec
    rm -f "$(rpm -E %_srcrpmdir)"/gnuxc-*.src.rpm

**Delete this directory.**  The last step for a complete uninstall is to remove
this project itself.  Once it's gone, everything installed here (except distro
RPMs from build dependencies) should be purged from your build system.
