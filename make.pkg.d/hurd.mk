hurd                    := hurd-0.8-bc1701
hurd_branch             := master
hurd_sha1               := bc170131016969f1d79409337833046ae1f4501b
hurd_url                := git://git.sv.gnu.org/hurd/hurd.git

$(prepare-rule):
	$(call apply,console-nocaps fancy-motd trap-console fhs)

$(configure-rule):
	cd $(builddir) && ./$(configure) \
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

$(build-rule):
	$(MAKE) -C $(builddir) all
	$(MAKE) -C $(builddir)/doc all
	$(MAKE) -C $(builddir)/hurd hurd.msgids

$(install-rule): $$(call installed,gnumach unifont)
	$(MAKE) -C $(builddir) install prefix=$(DESTDIR) \
		INSTALL-{ids,login,mail.local,ps,w}-ops='-m 4755'
	$(SYMLINK) halt $(DESTDIR)/sbin/poweroff
	test -e $(DESTDIR)/sbin/init || $(SYMLINK) runsystem $(DESTDIR)/sbin/init
	$(RM) $(DESTDIR)/dev/MAKEDEV

	$(MOVE) $(DESTDIR)/hurd/tmpfs $(DESTDIR)/hurd/tmpfs.bin
	$(INSTALL) -Dpm 0755 $(call addon-file,tmpfs.sh) $(DESTDIR)/hurd/tmpfs

	$(INSTALL) -Dpm 0644 $(call addon-file,console.scm) $(DESTDIR)/etc/shepherd.d/console.scm
	$(INSTALL) -Dpm 0644 $(call addon-file,runttys.scm) $(DESTDIR)/etc/shepherd.d/runttys.scm
	$(INSTALL) -Dpm 0644 $(call addon-file,swap.scm) $(DESTDIR)/etc/shepherd.d/swap.scm
	$(INSTALL) -Dpm 0600 $(call addon-file,random-seed) $(DESTDIR)/var/lib/hurd/random-seed
	$(INSTALL) -Dpm 0644 $(call addon-file,tmpfiles.conf) $(DESTDIR)/usr/lib/tmpfiles.d/hurd.conf
	$(INSTALL) -Dpm 0644 $(builddir)/console/motd.UTF8 $(DESTDIR)/etc/motd.UTF8

	$(INSTALL) -dm 0755 $(DESTDIR)/usr/share/hurd
	$(SYMLINK) ../fonts/unifont/unifont.bdf $(DESTDIR)/usr/share/hurd/vga-system.bdf
#	$(SYMLINK) vga-system.bdf $(DESTDIR)/usr/share/hurd/vga-system-bold.bdf
#	$(SYMLINK) vga-system.bdf $(DESTDIR)/usr/share/hurd/vga-system-bold-italic.bdf
#	$(SYMLINK) vga-system.bdf $(DESTDIR)/usr/share/hurd/vga-system-italic.bdf

	$(INSTALL) -Dm 0644 /dev/null $(DESTDIR)/servers/exec
	$(INSTALL) -Dm 0644 /dev/null $(DESTDIR)/servers/startup
	$(INSTALL) -Dm 0644 /dev/null $(DESTDIR)/servers/socket/1

	$(INSTALL) -dm 0755 $(DESTDIR)/home
	$(INSTALL) -dm 0755 $(DESTDIR)/run
	$(INSTALL) -dm 0755 $(DESTDIR)/var/{cache,lib/misc,log,spool}
	$(INSTALL) -dm 1777 $(DESTDIR){,/var}/tmp
	$(SYMLINK) run/lock $(DESTDIR)/var/lock
	$(SYMLINK) ../run $(DESTDIR)/var/run

# Write inline files.
$(call addon-file,console.scm runttys.scm swap.scm tmpfiles.conf tmpfs.sh): | $$(@D)
	$(file >$@,$(contents))
$(prepared): $(call addon-file,console.scm runttys.scm swap.scm tmpfiles.conf tmpfs.sh)

# Provide a seed for /dev/urandom since Hurd's /dev/random doesn't use entropy.
$(call addon-file,random-seed): | $$(@D)
	dd if=/dev/urandom of=$@ bs=1 count=600
$(built): $(call addon-file,random-seed)


# Provide a system service definition for "console", the Hurd console client.
override define contents
(define console-command
  '("/bin/console"
    "-c" "/dev/vcs"
    "-d" "current_vcs"
    "-d" "pc_kbd" "--repeat=kbd"
    "-d" "pc_mouse" "--repeat=mouse"
    "-d" "vga" "--font-width=8"))
(make <service>
  #:docstring "The console service controls the Hurd console client."
  #:provides '(console)
  #:requires '(runttys)
  #:start (make-forkexec-constructor console-command)
  #:stop (make-kill-destructor))
endef
$(call addon-file,console.scm): private override contents := $(value contents)


# Provide a system service definition for "runttys", the getty launcher.
override define contents
(define (runttys-start . args)
  (let ((pid (fork+exec-command '("/sbin/runttys"))))
    (for-each
      (lambda (signum) (sigaction signum (lambda (sig) (kill pid sig))))
      (list SIGTERM SIGINT SIGHUP SIGTSTP))
    (usleep 250000) ; Wait a quarter of a second for login programs to start.
    pid))
(make <service>
  #:docstring "The runttys service reads /etc/ttys and starts those programs."
  #:provides '(runttys)
  #:requires '()
  #:start runttys-start
  #:stop (make-kill-destructor))
endef
$(call addon-file,runttys.scm): private override contents := $(value contents)


# Provide a system service definition for "swap", the swap partition handler.
override define contents
(define (swap-start . args) (zero? (system* "/sbin/swapon" "--standard")))
(define (swap-stop running . args) (system* "/sbin/swapoff" "--standard"))
(make <service>
  #:docstring "The swap service enables and disables swap partitions."
  #:provides '(swap)
  #:requires '()
  #:respawn? #f
  #:start swap-start
  #:stop swap-stop)
endef
$(call addon-file,swap.scm): private override contents := $(value contents)


# Provide the configuration to create base files in /run on boot.
override define contents
d /run/lock
L /run/mtab - - - - ../proc/mounts
F! /run/utmp 0664
endef
$(call addon-file,tmpfiles.conf): private override contents := $(value contents)


# Provide a tmpfs translator wrapper that ensures mach-defpager is running.
override define contents
#!/bin/sh
/hurd/mach-defpager
exec -a "$0" /hurd/tmpfs.bin "$@"
endef
$(call addon-file,tmpfs.sh): private override contents := $(value contents)
