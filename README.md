# GNU OS Cross-Compiler

## About

This project is a GNU operating system cross-compiler, named `gnuxc` for short.
It will create a fairly complete, Hurd-based, free software OS by using Fedora
as the build system.  The resulting GNU system uses a default configuration
tailored for a `qemu` runtime environment.

It has two distinct components for building a working operating system:

1. *Sysroot libraries and cross-tools packages*:  These are maintained in RPMs
   targeting the latest Fedora release.  They provide a GNU (Hurd) development
   environment on the build system, a standard base of software to run and link
   against when compiling the operating system itself.  Their build files are
   located in `specs` and `patches`.

2. *Operating system compilation rules*:  The options and procedures used to
   build all of the OS software are contained in `make.pkg.d` and `patches`.
   These build files are mostly reusable on the GNU system to rebuild packages.

In addition to these components, a documentation file `BUILD.md` is provided to
explain the process of compilation, creating a disk image, and running the OS
virtually.

All sample commands in the documentation can be pasted directly into a `bash`
terminal.  Some of the commands require your account to have `sudo` access, for
example to install system packages or work with loop devices.


## Requirements

The following table lists the minimum and recommended system requirements for
the build system and the virtual/emulated `qemu` guest.

                         Build Min   Build Rec   QEMU Min   QEMU Rec
    Operating System :   Fedora 18   Fedora 19   GNU        GNU
    Available Storage:    10 GiB      20 GiB       2 GiB     10 GiB
    Installed Memory :     1 GiB       8 GiB     128 MiB      1 GiB
    Logical CPU Cores:     1 core      8 cores     1 core     1 core

Testing is likely to only happen on the latest stable Fedora.  The previous
version will be tested for (at most) a few weeks after a newer release, but it
is unlikely that massive incompatibilities will arise in older releases.

After compiling all currently available packages, the build directory requires
at least 8 GiB of disk space.  The installed system should have at least 2 GiB.
The build system therefore needs a minimum of 10 GiB free disk space.

When compiling, more RAM and CPU cores are always better.  The recommended
values only reflect what is used during testing.

For best results running the GNU Hurd system, your virtual host should be an
`x86` system with KVM support.


## Install

The `gnuxc` source directory is functional from any filesystem location; an
unprivileged user account can run everything out of its home directory.  If a
shared install is desired, the entire `gnuxc` directory can be placed in a
read-only system location such as `/usr/share/gnuxc`.

The `make` file in the source directory can be called from anywhere to compile
all the packages in a dedicated location.  All of the commands given in this
documentation take the current working directory as your desired build path.

To work with the option of separate source/build directories, some of the given
commands read the `SOURCE_DIR` variable for the absolute path to build files.
Example:

    SOURCE_DIR=/usr/share/gnuxc

If you haven't set this, the affected commands will assume the `gnuxc` source
directory is both your current working directory and desired build path.


## License

Files written specifically for this cross-compilation system (i.e., not patches
to other projects) are distributed under `GPLv3+` terms.  The full text of this
license is included in a `COPYING` file under the `patches` directory.

The changes in the patch files should be considered under the same license as
the files they modify, to ease merging of the patches upstream if appropriate.

Some patches are unreleased fixes pulled directly from version control systems;
these files' licensing terms are determined by the respective authors/projects.


## Quick Update Guide

The following steps can be run after updating the `gnuxc` files to rebuild the
entire updated OS from scratch.  You *must* run the full build process at least
once before this will work.  See `BUILD.md` for complete instructions.

**Remove old packages.**

    rm -fr "$(rpm -E %_rpmdir)"
    sudo yum -y remove 'gnuxc-*'
    gmake clean

**Update RPM build files.**

    gmake dist-{glibc,gnumach,hurd,libpthread,mig}
    mv -f {glibc,gnumach,hurd,libpthread,mig}-*.tar.xz "$(rpm -E %_sourcedir)/"
    ln -fs "${SOURCE_DIR:-$PWD}"/patches/* "$(rpm -E %_sourcedir)/"
    ln -fs "${SOURCE_DIR:-$PWD}"/specs/* "$(rpm -E %_specdir)/"

**Rebuild the system.**  This assumes you've mounted the target disk image over
`gnu-root` beforehand.  Don't forget the filesystem correction steps afterward.

    time bash "${SOURCE_DIR:-.}/setup-sysroot.sh"
    time ( gmake prepare && gmake $(rpm -E %_smp_mflags) && gmake install )
