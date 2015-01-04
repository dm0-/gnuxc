hurd                    := hurd-0.5-c0c693
hurd_branch             := master
hurd_snap               := c0c69366ce4717fb8c5db370ac42ab787782e28c
hurd_url                := git://git.sv.gnu.org/hurd/hurd.git

prepare-hurd-rule:
	$(PATCH) -d $(hurd) < $(patchdir)/$(hurd)-console-nocaps.patch
	$(PATCH) -d $(hurd) < $(patchdir)/$(hurd)-trap-console.patch
	$(PATCH) -d $(hurd) < $(patchdir)/$(hurd)-drop-libexec.patch
# Fix missing mig client objects.
	$(EDIT) 's/task_notifyServer\.o/& task_notifyUser.o/' $(hurd)/proc/Makefile

configure-hurd-rule:
	cd $(hurd) && ./$(configure) \
		--prefix= \
		--datarootdir='$${prefix}/usr/share' \
		--includedir='$${prefix}/usr/include' \
		--libexecdir='$${prefix}/sbin' \
		--localstatedir='$${prefix}/var' \
		--sysconfdir='$${prefix}/etc' \
		--with-libbz2 \
		--with-libz \
		\
		--without-libdaemon

build-hurd-rule:
	$(MAKE) -C $(hurd) -j1 all
	$(MAKE) -C $(hurd)/doc all
	$(MAKE) -C $(hurd)/hurd hurd.msgids

install-hurd-rule: $(call installed,gnumach unifont)
	$(MAKE) -C $(hurd) install prefix=$(DESTDIR) \
		INSTALL-{ids,login,mail.local,ps,w}-ops='-m 4755'
	$(SYMLINK) halt $(DESTDIR)/sbin/poweroff
	test -e $(DESTDIR)/sbin/init || $(SYMLINK) runsystem $(DESTDIR)/sbin/init
	$(RM) $(DESTDIR)/dev/MAKEDEV

	$(MOVE) $(DESTDIR)/hurd/tmpfs $(DESTDIR)/hurd/tmpfs.bin
	$(INSTALL) -Dpm 0755 $(hurd)/tmpfs.sh $(DESTDIR)/hurd/tmpfs

	$(INSTALL) -Dpm 0644 $(hurd)/console.scm $(DESTDIR)/etc/dmd.d/console.scm
	$(INSTALL) -Dpm 0644 $(hurd)/runttys.scm $(DESTDIR)/etc/dmd.d/runttys.scm
	$(INSTALL) -Dpm 0644 $(hurd)/swap.scm $(DESTDIR)/etc/dmd.d/swap.scm
	$(INSTALL) -Dpm 0644 $(hurd)/console/motd.UTF8 $(DESTDIR)/etc/motd.UTF8
	$(INSTALL) -Dpm 0600 $(hurd)/random-seed $(DESTDIR)/var/lib/hurd/random-seed
	$(INSTALL) -Dpm 0644 $(hurd)/tmpfiles.conf $(DESTDIR)/usr/lib/tmpfiles.d/hurd.conf

	$(INSTALL) -dm 0755 $(DESTDIR)/usr/share/hurd
	$(SYMLINK) ../fonts/unifont/unifont.bdf $(DESTDIR)/usr/share/hurd/vga-system.bdf
#	$(SYMLINK) vga-system.bdf $(DESTDIR)/usr/share/hurd/vga-system-bold.bdf
#	$(SYMLINK) vga-system.bdf $(DESTDIR)/usr/share/hurd/vga-system-bold-italic.bdf
#	$(SYMLINK) vga-system.bdf $(DESTDIR)/usr/share/hurd/vga-system-italic.bdf

	$(INSTALL) -Dm 0644 /dev/null $(DESTDIR)/servers/exec
	$(INSTALL) -Dm 0644 /dev/null $(DESTDIR)/servers/startup
	$(INSTALL) -Dm 0644 /dev/null $(DESTDIR)/servers/socket/1

	$(INSTALL) -dm 0755 $(DESTDIR)/home
	$(INSTALL) -dm 0755 $(DESTDIR)/var/{cache,lib/misc,log,run,spool}
	$(INSTALL) -dm 1777 $(DESTDIR){,/var}/tmp
	$(SYMLINK) run/lock $(DESTDIR)/var/lock

# Provide a system service definition for "console", the Hurd console client.
$(hurd)/console.scm: | $(hurd)
	$(ECHO) -e "(define console-command\n  '"'("/bin/console"' > $@
	$(ECHO) -e '    "-c" "/dev/vcs"\n    "-d" "current_vcs"\n    "-d" "pc_kbd" "--repeat=kbd"' >> $@
	$(ECHO) -e '    "-d" "pc_mouse" "--repeat=mouse"\n    "-d" "vga" "--font-width=8"))' >> $@
	$(ECHO) -e '(make <service>\n  #:docstring "The console service controls the Hurd console client."' >> $@
	$(ECHO) -e "  #:provides '(console)\n  #:requires '(runttys)" >> $@
	$(ECHO) -e '  #:start (make-forkexec-constructor console-command)\n  #:stop (make-kill-destructor))' >> $@
$(call prepared,hurd): $(hurd)/console.scm

# Provide a system service definition for "runttys", the getty launcher.
$(hurd)/runttys.scm: | $(hurd)
	$(ECHO) -e "(define (runttys-start . args)\n  (let ((pid (fork+exec-command '"'("/sbin/runttys"))))\n    (for-each' > $@
	$(ECHO) -e '      (lambda (signum) (sigaction signum (lambda (sig) (kill pid sig))))' >> $@
	$(ECHO) -e '      (list SIGTERM SIGINT SIGHUP SIGTSTP))' >> $@
	$(ECHO) -e '    (usleep 200000) ; Wait a fifth of a second for login programs to start.\n    pid))' >> $@
	$(ECHO) -e '(make <service>\n  #:docstring "The runttys service reads /etc/ttys and starts those programs."' >> $@
	$(ECHO) -e "  #:provides '(runttys)\n  #:requires '()" >> $@
	$(ECHO) -e '  #:start runttys-start\n  #:stop (make-kill-destructor))' >> $@
$(call prepared,hurd): $(hurd)/runttys.scm

# Provide a system service definition for "swap", the swap partition handler.
$(hurd)/swap.scm: | $(hurd)
	$(ECHO) '(define (swap-start . args) (zero? (system* "/sbin/swapon" "--standard")))' > $@
	$(ECHO) '(define (swap-stop running . args) (system* "/sbin/swapoff" "--standard"))' >> $@
	$(ECHO) -e '(make <service>\n  #:docstring "The swap service enables and disables swap partitions."' >> $@
	$(ECHO) -e "  #:provides '(swap)\n  #:requires '()\n  #:respawn? #f" >> $@
	$(ECHO) -e '  #:start swap-start\n  #:stop swap-stop)' >> $@
$(call prepared,hurd): $(hurd)/swap.scm

# Provide the configuration to create base files in /var.
$(hurd)/tmpfiles.conf: | $(hurd)
	$(ECHO) 'd /var/run/lock' > $@
	$(ECHO) 'L /var/run/mtab - - - - ../../proc/mounts' >> $@
	$(ECHO) 'F! /var/run/utmp 0664' >> $@
$(call prepared,hurd): $(hurd)/tmpfiles.conf

# Provide a tmpfs translator wrapper that ensures mach-defpager is running.
$(hurd)/tmpfs.sh: | $(hurd)
	$(ECHO) -e '#!/bin/sh\n/hurd/mach-defpager\nexec -a "$$0" /hurd/tmpfs.bin "$$@"' > $@
$(call prepared,hurd): $(hurd)/tmpfs.sh

# Provide a random seed file so it doesn't need to be generated at runtime.
$(hurd)/random-seed: | $(hurd)
	dd if=/dev/random of=$@ bs=1 count=600
$(call built,hurd): $(hurd)/random-seed
