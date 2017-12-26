# GNU OS Cross-Compiler - News

## 2017-12-25

This snapshot is from around the release of Fedora 27.

The following details highlight some of the bigger features that were added to
the build system and OS.


### Rust support

Rust projects are now supported via cross-compilation.  Hurd target libraries
are built and installed such that running `cargo build --target=i686-pc-gnu`
will result in usable binaries.  This also requires the environment variable
`RUST_TARGET_PATH=/usr/lib/rustlib/i686-pc-gnu` to be set until Rust defines a
default target search path.

To build Rust source without relying on Cargo, create the following alias (or
wrapper script) to mimic a cross-compiler program.

    alias i686-pc-gnu-rustc="\
    RUST_TARGET_PATH=/usr/lib/rustlib/i686-pc-gnu rustc \
    --codegen=ar=i686-pc-gnu-gcc-ar \
    --codegen=linker=i686-pc-gnu-gcc \
    --target=i686-pc-gnu"

The librsvg package has been upgraded to a development snapshot which utilizes
Rust and Cargo.


### GnuPG

The GNU Privary Guard is included in the operating system, and the build system
uses it to verify all downloaded source packages that are signed by their
upstream maintainers.


### Color fonts

Rendering color fonts is now supported by default in Cairo applications.

Google's Noto color emoji font has been added, and GTK+ 3 has a new emoji
chooser widget to exercise it.


### Build system upgrades

The build system and all upstream projects have completely dropped all reliance
on Python 2 when run on Fedora 26 or later, with the exception of IceCat.  Run
`gmake exclude=icecat ...` to skip it if Python 2 is not installed.

Deprecated compiler definitions, where the `CC` variable specified the compiler
program and machine-specific flags, have been removed.  All projects are now
built using properly separated build and host `CFLAGS`.

RPM macros have been better aligned with Fedora's conventions, so for example,
user settings like `%_configure_disable_silent_rules` have the intended effect.

The `debuginfo` subpackages were renamed to `debug` to work around new bad
behavior hard-coded into RPM 4.14.



## 2017-07-04

This snapshot is from around the release of Fedora 26.

The following details highlight some of the bigger features that were added to
the build system and OS.


### Rump kernel servers

The rump kernel's user space components, including the `rump_server` command
and driver libraries, are now installed.  They can be used to run NetBSD kernel
instances as regular processes, gaining support for additional hardware and
file systems, among other features.


### Audio support

A Shepherd service file `/etc/shepherd.d/rump.scm` is provided to start a rump
kernel server with a default configuration that drives PCI AC97 sound cards.  A
translator at `/dev/audio` is defined to convert Solaris audio device calls on
Hurd to NetBSD's audio device calls on this rump server.

PulseAudio is now installed, configured to use the Solaris backend.  Programs
such as IceCat and XBoard use it to play sounds.  Its `paplay` command can play
audio files directly.  EMMS has been added to use Emacs as a music player.

Codecs for a variety of free audio formats are installed, notably WAV, RAW,
FLAC, Speex, and Ogg/Vorbis.

Transparent audio passthrough has been added to the HAL project, by enabling
OSS emulation in the Linux-libre kernel and building QEMU's OSS audio driver.


### Runlevel service set changes

The set of enabled services is now defined by files present in `/etc/rcX.d`,
where *X* is the runlevel number.  This allows drop-in configuration, so each
package can enable itself on installation without editing files.

New services are enabled by default: DHCP networking, a cron daemon, syslog,
and a rump kernel server for audio support.


### Central core dump storage

The Hurd `crash` server has been updated to save all core files to `/var/crash`
whenever a program crashes.  The file names in this directory contain the time
when the crash occurred followed by the crashed PID.  This can be customized by
changing the translator at `/servers/crash`.


### New tmpfiles program

The `tmpfiles` program has been replaced by the POSIX shell implementation from
OpenRC, opentmpfiles.  It should support all functionality used by the previous
version as well as better conform to the systemd specification.



## 2016-07-04

This snapshot is from around the release of Fedora 24.

The following details highlight some of the bigger features that were added to
the build system and OS.


### Init system upgrade

GNU dmd has been renamed to GNU Shepherd.  The command `dmd` is now `shepherd`,
and `deco` is now `herd`.  The equivalent name changes have been made to system
configuration and logging paths.  The relevant scripts and documentation have
been updated to match.

The system initialization script (now `/etc/shepherd.scm`) includes some fake
runlevel support.  It allows keeping different lists of services to start on
boot, and the boot command line can select which one to use.

Some more of the existing projects have had services defined to be herded by
Shepherd, including Git.


### ImageMagick support

The flexible image manipulation tools from ImageMagick are now installed.  This
also enables support for many new image formats in existing packages; for
example, Emacs and Window Maker can now render SVG files.


### Networking improvements

All of the documented QEMU configurations should now be safe to enable the DHCP
client service, or start it with `sudo herd start dhclient`.  Its runtime
configuration has also been updated to support read-only root file systems.

The Linux-libre wrapper now includes some rudimentary wireless support.  Its
virtual Hurd guest is still presented with an Ethernet device to ensure full
hardware compatibility.  To make wireless configuration easier, you can hold
`Ctrl` while the Linux-libre kernel is booting to be presented with a series of
settings prompts.


### Improved games

Games with shared scores files will now write them under `/var/games` owned by
the `games` group.

XBoard, the graphical interface to GNU Chess, was updated to a Git snapshot in
order to move to GTK+ 3.

GNU Shogi was also updated to a Git snapshot in order to add XBoard support,
which replaces the XShogi package.  GNU Mini-Shogi is now installed as well.

GNU Go was integrated into Emacs, complete with a graphical board interface.

The classic dungeon exploration game NetHack was added.


### Build system upgrades

A `download` step has been added before `prepare`.  It stops after downloading
all files for the specified projects, allowing inspection before any patching
etc. takes place from the `prepare` step.  The build system should not require
network connectivity after the `gmake download` command successfully ends.

All downloaded files have their SHA-1 sums verified.  If the SHA-1 sum of a
downloaded file does not match its expected value, the project will fail before
any of its code can be executed.  (This check has not yet been added for the
sysroot package sources.)

The sysroot packages now process dependencies from their `pkg-config` files.
This defines most of the development packages' requirements automatically.  The
automatic `Provides` shouldn't be used for `BuildRequires`, however, since they
can't be known before building the packages, and that will break the dependency
tree generation in the sysroot builder script.



## 2015-11-24

This snapshot from around the Fedora 23 release is mostly about upgrades and
bug fixes.  Some notable upgrades are GCC 5, Python 3.5, IceCat 38, and all of
the core GNU components (gnumach, hurd, libpthread, glibc).

The following details highlight some of the bigger features that were added to
the build system and OS.


### GTK+ version 3 migration

The latest version of the GTK+ widget toolkit is now available.  Its default
icon theme Adwaita and the shared MIME info database have also been installed
to support it.

An installation of the latest GTK+ 2 libraries will still be included while
there are projects in the process of being ported to GTK+ 3.


### OpenGL support

The Mesa project is now included to support OpenGL applications via software
rendering.  Other packages will build their OpenGL functionality as well, such
as the `GtkGlArea` widget in GTK+ and WebGL in IceCat.


### TCL/TK language support

The TCL/TK libraries and their script interpreters (`tclsh` and `wish`) are now
installed.  Existing packages' TCL extensions are also enabled, including Git's
`git gui` and `gitk`, Python's `tkinter` and IDLE, and SQLite's TEA interface.


### Boot to XDM

A GNU dmd service `xdm` was added to start a graphical login prompt.  Replace
`console` with `xdm` in `/etc/dmdconf.scm` to make it the default on boot.
Selecting "Exit Window Maker" from the right-click menu will log out the
current user and return to the XDM login screen.  Running `sudo deco stop xdm`
will drop back to the Hurd console.


### Build system upgrades

Smaller custom files that need to be installed on the final OS image are now
expressed inline with GNU Make's multi-line variables, and they are written by
its `file` function for better readability and performance.

The project Makefiles have been restructured so that their build steps' times
of completion are recorded in the project directories.  This allows changing
package versions back and forth while preserving their individual build states.
Makefiles have also mostly had references to their own names removed, so new
packages can be easily based off existing ones by copying them.

The sysroot builders and documentation now use Fedora's new package management
tool, DNF.  This allowed shifting the bootstrapping switches from reliance on
an environment variable to RPM macros, which adds support for the RPM options
`--with=bootstrap` and `--without=bootstrap`.

The cross-compiler specs were reworked to conform to Fedora's newer packaging
guidelines about licenses and bootstrapping.  They were also rebuilt using
`mock`, so all of the packages are sure to have complete build requirements.



## 2015-01-04

This snapshot from around the Fedora 21 release adds many enhancements toward a
complete desktop distribution.  Some notable packages now included are IceCat,
sudo, and Python 3.

The following details highlight some of the bigger features that were added to
the build system and OS.


### Daemon management

GNU dmd is now used as the init program.  System daemons can be controlled with
the `deco` command.  A `service` command is also provided for compatibility
with other common init systems.  Examples:

    # Stop the Hurd console client to revert to the GNU Mach console
    sudo deco stop console

    # Reload /etc/cron.d/* and /etc/crontab configuration
    sudo service cron restart

    # Print the status of all defined services
    sudo deco status dmd

Many of the packages now have drop-in configuration directories to make project
installation etc. more manageable.  Some important daemon configurations:

  * *dmd*: The configuration file `/etc/dmdconf.scm` is executed on boot, which
    registers service definitions from `/etc/dmd.d/*.scm` files by default.

  * *mcron*: The cron daemon has its main `/etc/crontab` file, and it reads all
    `/etc/cron.d/*` files with the same syntax.

  * *syslogd*: The syslog daemon has its main `/etc/syslog.conf` file, and it
    reads all `/etc/syslog.d/*.conf` files with the same syntax.


### Portability via GNU Linux-libre

A new custom project `hal.mk` has been added to provide a virtual hardware
environment that is compatible with Hurd and Mach.  It installs an additional
kernel and initrd to support choosing this environment at boot time.

Note that when running in this virtual environment, shutting down the guest
shuts down the host as well, but rebooting only reboots the guest system.  To
reboot the host, first reboot the guest to get back to the guest bootloader,
then press `Ctrl+Alt+Esc` to terminate the guest and get a host console.  You
can run `reboot -f` or `poweroff -f` to restart or stop the host, respectively.

To ensure the Linux-libre kernel will work with your systems' hardware, run the
following to verify the configuration menu before compiling everything.

    gmake configure-hal-linux-libre
    make -C hal-*/linux-libre-*/ menuconfig

Steps to create an EFI system partition have been added to the example build
procedure document.  It uses the Linux-libre kernel to handle the actual EFI
boot and proceeds to run Hurd virtually.


### Theme extension

The `theme.mk` project aims to eventually apply a unified theme across the
various environments in the OS.  It has added a new section to theme the Apple
firmware disk selection entry.

The GRUB theme has also been updated and will now display a Linux-libre logo
when it detects that it is running in the included virtual environment.


### Temporary file systems

Both `/tmp` and `/var/run` are now `tmpfs` by default.  This entails a few
changes to earlier behavior.

  * The system is more usable when started with a read-only root file system
    now that services can write temporary files and runtime state information.

  * The `tmpfs` translator will now start `mach-defpager` by itself if it's not
    already running to ensure files can actually be written.  This is for early
    programs that need to write to `/var/run`, like GNU dmd.

A partially implemented `systemd-tmpfiles` alternative is provided by a script
`/sbin/tmpfiles` to initialize required files on `tmpfs` with a standardized
configuration.  It is first run by `/etc/dmdconf.scm`.


### Cross-compiling configure results

The file system package installs a `config.site` file in the sysroot to provide
the results of configure tests which can't be executed on the build system.


### New sysroot builder

A new script to build the sysroot `setup-sysroot.scm` is now included.  It is a
Scheme file and Make file.  When run with `make`, it will build every sysroot
RPM and install everything needed to build the OS by default.  When run with
`guile`, it will output a more typical Make file to do the same.  The following
two equivalent commands are replacements for `bash setup-sysroot.sh`:

    # Requires GNU Make 4.0 or later built with Guile support
    make -f setup-sysroot.scm -j16

    # Doesn't
    guile --no-auto-compile setup-sysroot.scm | make -f- -j16

There are major advantages of this method over the current serial build script:

  * It generates Make prerequisites from packages' BuildRequires, so a proper
    SRPM dependency tree is created on the fly for any spec files it can find.

  * The spec files and their produced SRPMs are the Make targets, so any failed
    builds can resume exactly where they were stopped, and packages are set to
    be rebuilt automatically when their spec files are updated.

  * All `make` commands in the RPMs' build scripts share the available job
    slots with the main process, ensuring a much more effective use of parallel
    processing within the specified parameters (e.g. `-j16` above).

The old serial shell script is still included in case the Guile script explodes
unexpectedly, but the Guile/Make method should be preferred going forward.
