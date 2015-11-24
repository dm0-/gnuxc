# GNU OS Cross-Compiler - News

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


### Temporary filesystems

Both `/tmp` and `/var/run` are now `tmpfs` by default.  This entails a few
changes to earlier behavior.

  * The system is more usable when started with a read-only root filesystem now
    that services can write temporary files and run-time state information.

  * The `tmpfs` translator will now start `mach-defpager` by itself if it's not
    already running to ensure files can actually be written.  This is for early
    programs that need to write to `/var/run`, like GNU dmd.

A partially implemented `systemd-tmpfiles` alternative is provided by a script
`/sbin/tmpfiles` to initialize required files on `tmpfs` with a standardized
configuration.  It is first run by `/etc/dmdconf.scm`.


### Cross-compiling configure results

The filesystem package installs a `config.site` file in the sysroot to provide
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
