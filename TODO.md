# GNU OS Cross-Compiler - Things to Fix

This is a list of significant pain points that I need to fix eventually.  Some
of these items are statements of problems, some suggest workarounds, and others
just note the terrible hacks in place to get a functioning system.

## Projects

### dmd

Both `/usr/sbin/halt` and `/usr/sbin/reboot` will break if dmd is not running.
In this case, you can explicitly call Hurd's `/sbin/halt` and `/sbin/reboot`.

### glibc

Since glib has a hard dependency on `CLOCK_MONOTONIC`, glibc now pretends to
support it by using `CLOCK_REALTIME` and hoping the clock won't change.

The name service caching daemon is disabled due to its usage of nptl being
incompatible with libpthread.

### gnutls

The default trusted CA file is `/etc/ssl/ca-bundle.pem`, but this file is not
provided at the moment.  Try stealing `/etc/pki/tls/cert.pem`, if you trust it.

### hal

The Linux-libre configuration only builds support for some of the hardware in
my immediate vicinity, so it's really not that portable without tweaking.

### hurd

There is no entropy behind `/dev/random`.

### icecat

It's a flaky, slow, experimental Hurd port with lots of debug options enabled.

### theme

The Apple EFI disk label images apparently only work with an ESP on HFS+, and I
don't feel like making two ESPs just for this.  Apple menus can stay icon-only.

### xdm

XDM started crashing a while ago due to assertion failures after some changes
in libpthread.  Call `startx` as a regular user to get at the desktop.

### xorg-server

When the X server exits, it can mess up the Hurd console screen resolution and
font rendering slightly.  Run `sudo service console restart` to correct it.

## Sysroot

### bootstrap

Do something about libpthread and libihash.

### filesystem

I need to write an autoconf file to run on the final OS image to regenerate the
`config.site` results to keep cross-compiling settings up to date with native.

### setup-sysroot.scm

This thing is still a "well, it works" hack.  I really should learn Guile.

Maybe look into automatically generating spec files from the Make files so that
there is only one source of build commands.
