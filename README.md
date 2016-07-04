# GNU OS Cross-Compiler

## About

This project is a GNU operating system cross-compiler, named `gnuxc` for short,
tailored to run on Fedora as the build system.  It can create a free, portable,
Hurd-based, desktop OS from scratch.

There are two distinct components for building a working operating system:

 1. *Sysroot libraries and cross-tools*:  These are packaged into RPMs for the
    latest Fedora release.  They provide a GNU Hurd cross-compiling environment
    on the build system, a standard base of software to run and link against
    when compiling software for the operating system itself.  Their build files
    are located in `specs` and `patches`.

 2. *Operating system compilation rules*:  The options and procedures used to
    build all of the OS software are contained in `make.pkg.d` and `patches`.
    These files are mostly reusable on the GNU system to rebuild or upgrade
    packages at runtime.

A documentation file `BUILD.md` is provided to walk-through the entire build
procedure and how to test running the OS virtually.  All sample commands in the
documentation can be pasted directly into a `bash` prompt.  Some of the
commands require your account to have `sudo` access, for example to install
system packages or work with loop devices.

The file `RUNTIME.md` documents how to use and configure the main environments
at runtime, especially the aspects that are unique to the `gnuxc` project.


## Requirements

*Operating system*:  Fedora 24 is the current release targeted by this code.

*Disk space*:  At least 20 GiB of total available storage is required when
building everything on the same machine, plus however much space is desired for
creating a virtual disk image.  Using solid-state storage for the working
directories will greatly improve build times.

  * Installing only the packages necessary to build the complete OS requires
    half a gigabyte.  This is the default action of the sysroot builder script.

  * The sysroot builder script leaves RPMs, SRPMs, and source archives on the
    disk after it finishes, requiring almost 2 GiB of disk space.  (This space
    can be reclaimed by removing the RPM build environment after installation.)

  * The main working directory will use a bit over 16 GiB after compilation.

*Memory*:  The build is usually tested on systems with at least 8 GiB of RAM.

*Processor(s)*:  The build has been tested on various CPUs ranging from 2-cores
under 2 GHz to 8-cores around 5 GHz.  Bigger is better.  The CPU should support
hosting a virtual `x86` guest with KVM for best results with running the OS.


## Install

The `gnuxc` source directory is self-contained, and it is functional from any
file system location.  To install it at a certain path, simply move or copy the
whole directory into place.

An unprivileged user account can run everything out of its home directory.  If
a shared install is desired, the `gnuxc` directory can be placed in a read-only
system location such as `/usr/share/gnuxc`.


## Usage

Calling the main `GNUmakefile` will build the projects in your current working
directory, or the path given to GNU Make with its `-C` option.

All commands in this documentation assume that your current directory is your
desired build path, so change to that directory before pasting any commands.

The given commands also assume your working directory is the `gnuxc` directory,
unless you set the `SOURCE_DIR` variable to its location.  (Note that this
variable is only a convention for the example commands; it is never used in the
actual project code.)  For example, run the following if `gnuxc` was installed
into `/usr/share`.

    SOURCE_DIR=/usr/share/gnuxc

See `BUILD.md` for a detailed walk-through of building the complete OS.


## License

Files written specifically for this cross-compilation system (i.e., not patches
to other projects) are distributed under `GPLv3+` terms.  The full text of this
license is included in a `COPYING` file under the `patches` directory.

The changes in the patch files should be considered under the same license as
the files they modify, to ease applying the patches upstream if appropriate.
Most patches are too trivial to warrant any copyright or licensing concerns.


## Quick Update Guide

The following steps can be run after updating the `gnuxc` files to rebuild the
entire updated OS from scratch.  You *must* run the full build process at least
once before this will work.  See `BUILD.md` for complete instructions.

**Remove old packages.**

    rm -fr "$(rpm -E %_rpmdir)" "$(rpm -E %_srcrpmdir)"
    sudo dnf -y remove 'gnuxc-*'
    gmake clean

**Update RPM source files.**

    ln -fst "$(rpm -E %_sourcedir)" "${SOURCE_DIR:-$PWD}"/patches/*
    ln -fst "$(rpm -E %_specdir)" "${SOURCE_DIR:-$PWD}"/specs/*

**Rebuild the system.**  This assumes that you've mounted your target disk over
`gnu-root` beforehand.  Don't forget to run the ownership correction step after
installation.

    time make -f "${SOURCE_DIR:-.}/setup-sysroot.scm" $(rpm -E %_smp_mflags)
    time ( gmake download && gmake $(rpm -E %_smp_mflags) && gmake install )
