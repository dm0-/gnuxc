setup                   := setup-1

prepare-setup-rule:
	$(DOWNLOAD) 'http://www.cl.cam.ac.uk/~mgk25/download/ucs-fonts.tar.gz' | $(TAR) -xzC $(setup) 9x15{,B}.bdf

	$(COPY) $(patchdir)/$(setup)-setup.sh    $(setup)/setup.sh
	$(COPY) $(patchdir)/$(setup)-profile.sh  $(setup)/profile

	$(ECHO) 'if [ -f ~/.bashrc ] ; then . ~/.bashrc ; fi' > $(setup)/bash_profile

	$(ECHO) "alias fix-disk='e2fsck -y /dev/hd0s1 ; reboot'" > $(setup)/root-bashrc
	$(ECHO) "alias start-console='console -d pc_kbd --repeat=kbd -d pc_mouse --repeat=mouse -d vga -d generic_speaker -c /dev/vcs'" >> $(setup)/root-bashrc

	$(ECHO) '(setq backup-directory-alist '"'"'((".*" . "~/.local/share/emacs/backups")))' > $(setup)/emacs
	$(ECHO) '(column-number-mode 1)' >> $(setup)/emacs
	$(ECHO) '(when (not (display-graphic-p)) (menu-bar-mode 0))' >> $(setup)/emacs

	$(TOUCH) $(setup)/fstab

	$(ECHO) '[user]' > $(setup)/gitconfig
	$(ECHO) -e '\tname = GNU Hacker' >> $(setup)/gitconfig
	$(ECHO) -e '\temail = root@localhost' >> $(setup)/gitconfig

	$(ECHO) 'root:*:0:' > $(setup)/group
	$(ECHO) 'nobody:*:-1:' >> $(setup)/group

	$(ECHO) '(use-modules (ice-9 readline))' > $(setup)/guile
	$(ECHO) '(activate-readline)' >> $(setup)/guile

	$(ECHO) gnu > $(setup)/hostname

	$(ECHO) '127.0.0.1 localhost gnu' > $(setup)/hosts

	$(ECHO) 'root:x:0:0:root:/root:/bin/bash' > $(setup)/passwd
	$(ECHO) 'nobody:*:-1:-1:nobody:/nowhere:/bin/false' >> $(setup)/passwd

	$(ECHO) 'domain lan' > $(setup)/resolv.conf
	$(ECHO) 'search lan' >> $(setup)/resolv.conf
	$(ECHO) 'nameserver 10.0.2.3' >> $(setup)/resolv.conf

	$(ECHO) 'root::0:0:-1:7:::' > $(setup)/shadow

	$(ECHO) 'exec /usr/bin/wmaker' > $(setup)/xinitrc

	$(ECHO) '(setq backup-directory "~/.local/share/zile/backups")' > $(setup)/zile

install-setup-rule: $(call installed,grep grub iana man-db procfs)
	$(INSTALL) -Dpm 644 $(setup)/fstab        $(DESTDIR)/etc/fstab
	$(INSTALL) -Dpm 644 $(setup)/group        $(DESTDIR)/etc/group
	$(INSTALL) -Dpm 644 $(setup)/hostname     $(DESTDIR)/etc/hostname
	$(INSTALL) -Dpm 644 $(setup)/hosts        $(DESTDIR)/etc/hosts
	$(SYMLINK) ../usr/share/zoneinfo/America/New_York $(DESTDIR)/etc/localtime
	$(INSTALL) -Dpm 644 $(setup)/passwd       $(DESTDIR)/etc/passwd
	$(INSTALL) -Dpm 644 $(setup)/profile      $(DESTDIR)/etc/profile
	$(INSTALL) -dm  755                       $(DESTDIR)/etc/profile.d
	$(INSTALL) -Dpm 644 $(setup)/resolv.conf  $(DESTDIR)/etc/resolv.conf
	$(INSTALL) -Dpm 000 $(setup)/shadow       $(DESTDIR)/etc/shadow
	$(INSTALL) -Dpm 644 $(setup)/bash_profile $(DESTDIR)/etc/skel/.bash_profile
	$(INSTALL) -Dpm 644 $(setup)/emacs        $(DESTDIR)/etc/skel/.emacs
	$(INSTALL) -Dpm 644 $(setup)/gitconfig    $(DESTDIR)/etc/skel/.gitconfig
	$(INSTALL) -Dpm 644 $(setup)/guile        $(DESTDIR)/etc/skel/.guile
	$(INSTALL) -dm  755                       $(DESTDIR)/etc/skel/.local/bin
	$(INSTALL) -dm  755                       $(DESTDIR)/etc/skel/.local/share/{emacs,zile}/backups
	$(INSTALL) -Dpm 644 $(setup)/xinitrc      $(DESTDIR)/etc/skel/.xinitrc
	$(INSTALL) -Dpm 644 $(setup)/zile         $(DESTDIR)/etc/skel/.zile

	$(INSTALL) -dm  750                       $(DESTDIR)/root
	$(COPY) -a $(DESTDIR)/etc/skel/.[a-z]*    $(DESTDIR)/root/
	$(INSTALL) -Dpm 644 $(setup)/root-bashrc  $(DESTDIR)/root/.bashrc
	$(INSTALL) -Dpm 644 $(setup)/setup.sh     $(DESTDIR)/root/setup.sh

	$(INSTALL) -Dpm 644 $(setup)/9x15.bdf     $(DESTDIR)/usr/share/hurd/vga-system.bdf
	$(INSTALL) -Dpm 644 $(setup)/9x15B.bdf    $(DESTDIR)/usr/share/hurd/vga-system-bold.bdf

# Tack on a copy of the build system tailored for rebuilding system components.
	$(ECHO) "alias gmake='make -f /usr/share/gnuxc/GNUmakefile'" > $(DESTDIR)/etc/profile.d/gnuxc.sh
	$(INSTALL) -dm 755 $(DESTDIR)/usr/share/gnuxc/{make.pkg.d,patches}
	$(INSTALL) -Dpm 644 $(pkgdir)/*.mk $(DESTDIR)/usr/share/gnuxc/make.pkg.d/
	$(INSTALL) -Dpm 644 $(patchdir)/*-*-* $(DESTDIR)/usr/share/gnuxc/patches/
	$(SED) < $(makefile) > $(DESTDIR)/usr/share/gnuxc/GNUmakefile \
		-e 's/^\(build *:\?=\).*/\1 $$(host)/' \
		-e 's/^\(export DESTDIR *:\?=\).*/\1/' \
		-e 's/^\(DOWNLOAD.*\) #.*/\1 --no-check-certificate/' \
		-e 's/^\(installed *:\?=\).*/\1/'
