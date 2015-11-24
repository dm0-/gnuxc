# GNU OS Cross-Compiler - Things to Fix

This is a list of significant pain points that I need to fix eventually.  Some
of these items are statements of problems, some suggest workarounds, and others
just note the terrible hacks in place to get a functioning system.

## Projects

### dhcp

Don't use this yet.  The kernel panics when modifying the `pfinet` server's
translator options.  Stick to static IPs for now.

### dmd

Both `/usr/sbin/halt` and `/usr/sbin/reboot` will break if dmd is not running.
In this case, you can explicitly call Hurd's `/sbin/halt` and `/sbin/reboot`.

### glibc

Since glib has a hard dependency on `CLOCK_MONOTONIC`, glibc now pretends to
support it by using `CLOCK_REALTIME` and hoping the clock won't change.

The name service caching daemon is disabled due to its usage of nptl being
incompatible with libpthread.

The getauxval() definition should probably be removed since it just segfaults.

### gnutls

The default trusted CA file is `/etc/ssl/ca-bundle.pem`, but this file is not
provided at the moment.  Try stealing `/etc/pki/tls/cert.pem`, if you trust it.

### gtk+

Get GTK+ 3 working better, and properly port the GTK+ 2 applications to it so
only the newest version is needed.

### hal

The Linux-libre configuration only builds support for some of the hardware in
my immediate vicinity, so it's really not that portable without tweaking.

Booting Hurd with Intel nested KVM stopped working around Linux 4.3 (or I broke
something in the config).  If you've set `kvm_intel.nested=1` on your host,
append `gnuxc.kvm=0` to the HAL boot command line to disable QEMU KVM support.
It also looked like it was doing the same thing natively on Lenovo hardware
last time I checked, so maybe the problem could even be in gnumach.

### hurd

There is no entropy behind `/dev/random`.

There is no audio support.

### icecat

It's a flaky, slow, experimental Hurd port.  Using Emacs to browse the web will
probably be more enjoyable.

### lsh

Seed files are currently just generated from Hurd's entropy-free `/dev/random`.

### theme

The Apple EFI disk label images apparently only work with an ESP on HFS+, and I
don't feel like making two ESPs just for this.  Apple menus can stay icon-only.

### xorg-server

When the X server exits, it can mess up the Hurd console screen resolution and
font rendering slightly.  Run `sudo deco restart console` to correct it.

## Sysroot

### bootstrap

Do something about libpthread and libihash.

Maybe prepend "%global bootstrap 1" to some specs that don't require a complete
GCC so there are more parallel builds happening during the bootstrap phase.

### filesystem

I need to write an autoconf file to run on the final OS image to regenerate the
`config.site` results to keep cross-compiling settings up to date with native.

### gcc

There is an issue where a C library using a C++ library can't find libstdc++
in the tools libdir during linking.  This is temporarily solved by symlinking
libstdc++ into the sysroot libdir.

### setup-sysroot.scm

This thing is still a "well, it works" hack.  I really should learn Guile.

Maybe look into automatically generating spec files from the Make files so that
there is only one source of build commands.  This could also potentially allow
OS-independent bootstrapping by generating an unpackaged sysroot as well.

DNF's locking doesn't work, so you can't run several installs in parallel and
expect it to wait properly.  To work around this, a big ugly locking mechanism
was added to force the builddep phase to run one-at-a-time.  Use the fallback
`setup-sysroot.sh` script if problems arise with this.

DNF also doesn't support setting options on temporary repositories, so it still
uses the ugly method of reading the configuration from a here-document.
