setup                   := setup-1

prepare-setup-rule:
	$(ECHO) 'if [ -f ~/.bashrc ] ; then . ~/.bashrc ; fi' > $(setup)/bash_profile
	$(ECHO) 'if [ -f /etc/bashrc ] ; then . /etc/bashrc ; fi' > $(setup)/user-bashrc

	$(ECHO) -e '/dev/hd0s2\t\t/\t\text2\tdefaults,rw\t\t1 1' > $(setup)/fstab

	$(ECHO) 'root:*:0:' > $(setup)/group
	$(ECHO) 'nobody:*:-1:' >> $(setup)/group
	$(ECHO) 'wheel:*:10:' >> $(setup)/group

	$(ECHO) gnu > $(setup)/hostname

	$(ECHO) '127.0.0.1 localhost gnu' > $(setup)/hosts

	$(ECHO) 'root:x:0:0:root:/root:$(BASH)' > $(setup)/passwd
	$(ECHO) 'nobody:*:-1:-1:nobody:/nowhere:/bin/false' >> $(setup)/passwd

	$(ECHO) 'domain localdomain' > $(setup)/resolv.conf
	$(ECHO) 'search localdomain' >> $(setup)/resolv.conf
	$(ECHO) 'nameserver 10.0.2.3' >> $(setup)/resolv.conf

	$(ECHO) 'root::0:0:-1:7:::' > $(setup)/shadow

	$(ECHO) '$(BASH)' > $(setup)/shells
	$(ECHO) /bin/sh >> $(setup)/shells

	$(ECHO) 'XTerm*backarrowKey: false' > $(setup)/Xdefaults
	$(ECHO) 'XTerm*background: #000000' >> $(setup)/Xdefaults
	$(ECHO) 'XTerm*cursorBlink: true' >> $(setup)/Xdefaults
	$(ECHO) 'XTerm*foreground: #FFFFFF' >> $(setup)/Xdefaults
	$(ECHO) 'XTerm*toolBar: false' >> $(setup)/Xdefaults
	$(ECHO) 'XTerm*ttyModes: erase ^?' >> $(setup)/Xdefaults

	$(ECHO) 'exec /usr/bin/wmaker' > $(setup)/xinitrc

install-setup-rule: $(call installed,grep iana theme)
	$(INSTALL) -dm  750                       $(DESTDIR)/root
# Install a systemd-tmpfiles replacement.
	$(INSTALL) -Dpm 755 $(setup)/tmpfiles.sh  $(DESTDIR)/sbin/tmpfiles
	$(INSTALL) -dm  755                       $(DESTDIR)/etc/tmpfiles.d
# Use an initialization script first as the system init to finish the install.
	$(INSTALL) -Dpm 755 $(setup)/setup.sh     $(DESTDIR)/hurd/setup.sh
	$(SYMLINK) ../hurd/setup.sh               $(DESTDIR)/sbin/init
# Set up the system configuration.
	$(INSTALL) -Dpm 644 $(setup)/bashrc       $(DESTDIR)/etc/bashrc
	$(INSTALL) -dm  755                       $(DESTDIR)/etc/bashrc.d
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
	$(INSTALL) -Dpm 644 $(setup)/shells       $(DESTDIR)/etc/shells
	$(INSTALL) -Dpm 644 $(setup)/bash_profile $(DESTDIR)/etc/skel/.bash_profile
	$(INSTALL) -Dpm 644 $(setup)/user-bashrc  $(DESTDIR)/etc/skel/.bashrc
	$(INSTALL) -dm  755                       $(DESTDIR)/etc/skel/.local/bin
	$(INSTALL) -Dpm 644 $(setup)/xinitrc      $(DESTDIR)/etc/skel/.xinitrc
	$(INSTALL) -Dpm 644 $(setup)/Xdefaults    $(DESTDIR)/etc/skel/.Xdefaults
# Tack on a copy of the build system tailored for rebuilding system components.
	$(INSTALL) -Dpm 644 $(setup)/user-bashrc  $(DESTDIR)/root/.bashrc
	$(ECHO) "alias gmake='make -C ~/wd.gnuxc -f /usr/share/gnuxc/GNUmakefile'" >> $(DESTDIR)/root/.bashrc
	$(INSTALL) -dm 755 $(DESTDIR)/root/wd.gnuxc
	$(INSTALL) -dm 755 $(DESTDIR)/usr/share/gnuxc/{make.pkg.d,patches}
	$(INSTALL) -pm 644 -t $(DESTDIR)/usr/share/gnuxc/make.pkg.d $(pkgdir)/*.mk
	$(INSTALL) -pm 644 -t $(DESTDIR)/usr/share/gnuxc/patches $(patchdir)/*-*-*
	$(SED) < $(makefile) > $(DESTDIR)/usr/share/gnuxc/GNUmakefile \
		-e 's/^\(export DESTDIR *:\?=\).*/\1/' \
		-e 's/^\(DOWNLOAD.*\) #.*/\1 --no-check-certificate/' \
		-e 's/^\(installed *:\?=\).*/\1/'

# Provide a post-installation OS initialization script.
$(setup)/setup.sh: $(patchdir)/$(setup)-setup.sh | $(setup)
	$(COPY) $< $@
$(call prepared,setup): $(setup)/setup.sh

# Provide a bash initialization script for every interactive shell.
$(setup)/bashrc: | $(setup)
	$(ECHO) -e '# Default shell configuration - aliases, functions, prompts\n#' > $@
	$(ECHO) '# This file is called by default user settings to run when starting interactive' >> $@
	$(ECHO) '# shell sessions.  See /etc/profile for configuration specific to login shells.' >> $@
	$(ECHO) -e '\n# Configure settings that depend on the terminal.' >> $@
	$(ECHO) 'PS1='\''[$$? \u@\h \W]\$$ '\' >> $@
	$(ECHO) 'case "$$TERM" in' >> $@
	$(ECHO) '        xterm*) PS1='\''\[\e];\u@\h:\w\a\]'\''$$PS1 ;;' >> $@
	$(ECHO) -e 'esac\nexport PS1\n\n# Include package-specific aliases and functions.' >> $@
	$(ECHO) 'for conf in /etc/bashrc.d/*.sh ; do . "$$conf" ; done' >> $@
$(call prepared,setup): $(setup)/bashrc

# Provide a bash initialization script for login shells.
$(setup)/profile: | $(setup)
	$(ECHO) -e '# Default shell configuration - environment\n#' > $@
	$(ECHO) '# This is executed by login shells, so its settings should be inherited by any' >> $@
	$(ECHO) '# subshells.  See /etc/bashrc for configuration of each shell instance.' >> $@
	$(ECHO) -e '\n# Choose a umask to give readability to everyone and writability to the owner.' >> $@
	$(ECHO) -e 'umask 0022\n\n# Set a default editor.' >> $@
	$(ECHO) -e 'EDITOR=emacs ; export EDITOR\nVISUAL=$$EDITOR ; export VISUAL' >> $@
	$(ECHO) -e '\n# Configure shell history to keep only useful records.' >> $@
	$(ECHO) -e 'HISTCONTROL=ignoreboth ; export HISTCONTROL\nHISTSIZE=1000 ; export HISTSIZE' >> $@
	$(ECHO) -e '\n# Select the default language/encoding.' >> $@
	$(ECHO) 'test "$${TERM%-color}" = mach-gnu && LANG=C || LANG=en_US.UTF-8 ; export LANG' >> $@
	$(ECHO) -e 'LANGUAGE=$$LANG ; export LANGUAGE\nLC_ALL=$$LANG ; export LC_ALL' >> $@
	$(ECHO) -e '\n# Choose a MOTD based on encoding.' >> $@
	$(ECHO) -e 'MOTD=/etc/motd ; test "$${LANG##*.}" = UTF-8 && MOTD=$$MOTD.UTF8 ; export MOTD' >> $@
	$(ECHO) -e '\n# Configure a default system path.' >> $@
	$(ECHO) 'PATH="~/.local/bin:/usr/bin:/usr/sbin:/bin:/sbin" ; export PATH' >> $@
	$(ECHO) -e '\n# Include package-specific environment settings.' >> $@
	$(ECHO) 'for conf in /etc/profile.d/*.sh ; do . "$$conf" ; done' >> $@
$(call prepared,setup): $(setup)/profile

# Provide a program to create a skeleton file structure in tmpfs directories.
$(setup)/tmpfiles.sh: $(patchdir)/$(setup)-tmpfiles.sh | $(setup)
	$(COPY) $< $@
$(call prepared,setup): $(setup)/tmpfiles.sh
