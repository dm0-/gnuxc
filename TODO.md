# GNU OS Cross-Compiler - Things to Fix

This is a list of significant pain points that I need to fix eventually.  Some
of these items are statements of problems, some suggest workarounds, and others
just note the terrible hacks in place to get a functioning system.

## Projects

### dhcp

Unbundle BIND.

### glibc

Since glib has a hard dependency on `CLOCK_MONOTONIC`, glibc now pretends to
support it by using `CLOCK_REALTIME` and hoping the clock won't change.

The name service caching daemon is disabled due to its usage of nptl being
incompatible with libpthread.

Figure out what dependencies broke to build librt before libpthread.

### gnutls

The default trusted CA file is `/etc/ssl/ca-bundle.pem`, but this file is not
provided at the moment.  Try stealing `/etc/pki/tls/cert.pem`, if you trust it.

### guile

Fix cross-compilation of everything that uses Guile for 2.2.

### gtk+

Build IceCat without GTK+ 2, and fix Emacs to run with GTK+ 3 to remove GTK+ 2.

### hal

The Linux-libre configuration only builds support for some of the hardware in
my immediate vicinity, so it's really not that portable without tweaking.

Audio passthrough was not yet tested on non-QEMU host platforms.

Add more wireless options in addition to WPA2 (WPA-PSK) and unencrypted.

It seems pointless to statically link both `qemu` and `wpa_supplicant` binaries
with the same C library.  Maybe compile the minimal required shared libraries
for the Linux target, so this won't rely on pre-built static libraries anymore.

### hurd

Get xattr translators working and use a Linux-compatible ext2 file system.

Try switching to lwIP.

### icecat

It's a flaky, slow, experimental Hurd port.  Using Emacs to browse the web will
probably be more enjoyable.

### inetutils

Add support for libidn2, since its features had to be disabled for the upgrade.

### pcre

Drop PCRE in favor of PCRE2.  This requires porting grep, less, wget, and glib.
Alternatively, wget could be replaced by wget2 to gain support for PCRE2.

### rump

Hook up NetBSD drivers to the Hurd PCI arbiter.

### shepherd

Both `/usr/sbin/halt` and `/usr/sbin/reboot` break if Shepherd is not running.
In this case, you can explicitly call Hurd's `/sbin/halt` and `/sbin/reboot`.

### theme

The Apple EFI disk label images apparently only work with an ESP on HFS+, and I
don't feel like making two ESPs just for this.  Apple menus can stay icon-only.

### xorg-server

When the X server exits, it can mess up the Hurd console screen resolution and
font rendering slightly.  Run `sudo herd restart console` to correct it.

## Build System

### sysroot

Maybe prepend `%global with_bootstrap 1` to specs that don't require a complete
GCC so there are more parallel builds happening during the bootstrap phase.

I need to write an autoconf file to run on the final OS image to regenerate the
`config.site` results to keep cross-compiling settings up to date with native.

There are some issues where a few GCC libraries in the tools libdir can't be
found during linking.  This is temporarily solved by symlinking them into the
regular sysroot libdir.  Maybe just put it all in the sysroot by default.

### setup-sysroot.scm

This thing is still a "well, it works" hack.  I really should learn Guile.

DNF can have `Transaction check error` failures when installing overlapping
package sets in parallel.  To work around this, a big ugly locking mechanism
was added to force the builddep phase to run one-at-a-time.  Use the fallback
`setup-sysroot.sh` script if problems arise with this.

DNF also doesn't support setting options on temporary repositories, so it still
uses the ugly method of reading the configuration from a here-document.

### specs

Maybe look into automatically generating spec files from the Make files so that
there is only one source of build commands.  This could also potentially allow
OS-independent bootstrapping by generating an unpackaged sysroot as well.

Assuming I don't go with automatically generated specs as noted above, combine
all devel subpackages into the main packages like with MinGW.
