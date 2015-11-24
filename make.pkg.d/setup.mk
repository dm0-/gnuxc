setup                   := setup-1

$(install-rule): $$(call installed,grep grub iana theme)
	$(INSTALL) -dm 750 $(DESTDIR)/root
# Install a systemd-tmpfiles replacement.
	$(INSTALL) -Dpm 755 $(call addon-file,tmpfiles.sh)   $(DESTDIR)/sbin/tmpfiles
	$(INSTALL) -dm  755                                  $(DESTDIR)/etc/tmpfiles.d
# Use an initialization script first as the system init to finish the install.
	$(INSTALL) -Dpm 755 $(call addon-file,setup.sh)      $(DESTDIR)/hurd/setup.sh
	$(SYMLINK) ../hurd/setup.sh                          $(DESTDIR)/sbin/init
# Set up the system configuration.
	$(INSTALL) -Dpm 644 $(call addon-file,bashrc)        $(DESTDIR)/etc/bashrc
	$(INSTALL) -dm  755                                  $(DESTDIR)/etc/bashrc.d
	$(INSTALL) -Dpm 644 $(call addon-file,fstab)         $(DESTDIR)/etc/fstab
	$(INSTALL) -Dpm 644 $(call addon-file,group)         $(DESTDIR)/etc/group
	$(INSTALL) -Dpm 644 $(call addon-file,hostname)      $(DESTDIR)/etc/hostname
	$(INSTALL) -Dpm 644 $(call addon-file,hosts)         $(DESTDIR)/etc/hosts
	$(SYMLINK) ../usr/share/zoneinfo/America/New_York    $(DESTDIR)/etc/localtime
	$(INSTALL) -Dpm 644 $(call addon-file,nsswitch.conf) $(DESTDIR)/etc/nsswitch.conf
	$(INSTALL) -Dpm 644 $(call addon-file,passwd)        $(DESTDIR)/etc/passwd
	$(INSTALL) -Dpm 644 $(call addon-file,profile)       $(DESTDIR)/etc/profile
	$(INSTALL) -dm  755                                  $(DESTDIR)/etc/profile.d
	$(INSTALL) -Dpm 644 $(call addon-file,resolv.conf)   $(DESTDIR)/etc/resolv.conf
	$(INSTALL) -Dpm 000 $(call addon-file,shadow)        $(DESTDIR)/etc/shadow
	$(INSTALL) -Dpm 644 $(call addon-file,shells)        $(DESTDIR)/etc/shells
	$(INSTALL) -Dpm 644 $(call addon-file,bash_profile)  $(DESTDIR)/etc/skel/.bash_profile
	$(INSTALL) -Dpm 644 $(call addon-file,user-bashrc)   $(DESTDIR)/etc/skel/.bashrc
	$(INSTALL) -dm  755                                  $(DESTDIR)/etc/skel/.local/bin
	$(INSTALL) -Dpm 644 $(call addon-file,Xdefaults)     $(DESTDIR)/etc/skel/.Xdefaults
	$(INSTALL) -Dpm 644 $(call addon-file,xinitrc)       $(DESTDIR)/etc/skel/.xinitrc
	$(INSTALL) -Dpm 644 $(call addon-file,xsession)      $(DESTDIR)/etc/skel/.xsession
# Tack on a copy of the build system tailored for rebuilding system components.
	$(INSTALL) -Dpm 644 $(call addon-file,user-bashrc) $(DESTDIR)/root/.bashrc
	$(ECHO) "alias gmake='make -C ~/wd.gnuxc -f /usr/share/gnuxc/GNUmakefile'" >> $(DESTDIR)/root/.bashrc
	$(INSTALL) -dm 755 $(DESTDIR)/root/wd.gnuxc
	$(INSTALL) -dm 755 $(DESTDIR)/usr/share/gnuxc/{make.pkg.d,patches}
	$(INSTALL) -pm 644 -t $(DESTDIR)/usr/share/gnuxc/make.pkg.d $(pkgdir)/*.mk
	$(INSTALL) -pm 644 -t $(DESTDIR)/usr/share/gnuxc/patches $(patchdir)/*-*-*
	$(SED) < $(makefile) > $(DESTDIR)/usr/share/gnuxc/GNUmakefile \
		-e 's/^\(export DESTDIR *:\?=\).*/\1/' \
		-e 's/^DOWNLOAD .*/& --no-check-certificate/' \
		-e 's/^\(installed *:\?=\).*/\1/'

# Write inline files.
$(call addon-file,bash_profile bashrc fstab group hostname hosts nsswitch.conf passwd profile resolv.conf shadow shells user-bashrc Xdefaults xinitrc xsession): | $$(@D)
	$(file >$@,$(contents))
$(prepared): $(call addon-file,bash_profile bashrc fstab group hostname hosts nsswitch.conf passwd profile resolv.conf shadow shells user-bashrc Xdefaults xinitrc xsession)

# Provide a post-installation OS initialization script.
$(call addon-file,setup.sh): $(patchdir)/$(setup)-setup.sh | $$(@D)
	$(COPY) $< $@
$(prepared): $(call addon-file,setup.sh)

# Provide a program to create a skeleton file structure in tmpfs directories.
$(call addon-file,tmpfiles.sh): $(patchdir)/$(setup)-tmpfiles.sh | $$(@D)
	$(COPY) $< $@
$(prepared): $(call addon-file,tmpfiles.sh)


# Provide a script that makes login sessions load interactive session settings.
override define contents
if [ -f ~/.bashrc ] ; then . ~/.bashrc ; fi
endef
$(call addon-file,bash_profile): private override contents := $(value contents)


# Provide a bash initialization script for every interactive shell.
override define contents
# Default shell configuration - aliases, functions, prompts
#
# This file is called by default user settings to run when starting interactive
# shell sessions.  See /etc/profile for configuration specific to login shells.

# Configure settings that depend on the terminal.
PS1='[$? \u@\h \W]\$ '
case "$TERM" in
        xterm*) PS1='\[\e];\u@\h:\w\a\]'$PS1 ;;
esac
export PS1

# Include package-specific aliases and functions.
for conf in /etc/bashrc.d/*.sh ; do . "$conf" ; done
endef
$(call addon-file,bashrc): private override contents := $(value contents)


# Provide a default file system table for fsck, etc.
override define contents
/dev/hd0s2		/		ext2	defaults,rw		1 1
endef
$(call addon-file,fstab): private override contents := $(value contents)


# Provide the table of group information.
override define contents
root:*:0:
login:*:1:
wheel:*:10:
nobody:*:-1:
endef
$(call addon-file,group): private override contents := $(value contents)


# Provide a default host name.
$(call addon-file,hostname): private override contents := gnu


# Provide a hosts table for name lookups without DNS.
$(call addon-file,hosts): private override contents := 127.0.0.1 localhost gnu


# Provide a configuration file specifying where to lookup system resources.
override define contents
group: files
hosts: files dns
passwd: files
protocols: files
services: files
shadow: files
endef
$(call addon-file,nsswitch.conf): private override contents := $(value contents)


# Provide the table of user information.
override define contents
root:x:0:0:root:/root:/bin/bash
login:*:1:1:Login Pseudo-user:/etc/login:/bin/loginpr
nobody:*:-1:-1:nobody:/nowhere:/bin/false
endef
$(call addon-file,passwd): private override contents := $(value contents)


# Provide a bash initialization script for login shells.
override define contents
# Default shell configuration - environment
#
# This is executed by login shells, so its settings should be inherited by any
# subshells.  See /etc/bashrc for configuration of each shell instance.

# Choose a umask to give readability to everyone and writability to the owner.
umask 0022

# Set a default editor.
EDITOR=emacs ; export EDITOR
VISUAL=$EDITOR ; export VISUAL

# Configure shell history to keep only useful records.
HISTCONTROL=ignoreboth ; export HISTCONTROL
HISTSIZE=1000 ; export HISTSIZE

# Select the default language/encoding.
test "${TERM%-color}" = mach-gnu && LANG=C || LANG=en_US.UTF-8 ; export LANG
LANGUAGE=$LANG ; export LANGUAGE
LC_ALL=$LANG ; export LC_ALL

# Configure a default system path.
PATH="~/.local/bin:/usr/bin:/usr/sbin:/bin:/sbin" ; export PATH

# Include package-specific environment settings.
for conf in /etc/profile.d/*.sh ; do . "$conf" ; done
endef
$(call addon-file,profile): private override contents := $(value contents)


# Provide a default DNS client configuration using the standard QEMU address.
override define contents
domain localdomain
search localdomain
nameserver 10.0.2.3
endef
$(call addon-file,resolv.conf): private override contents := $(value contents)


# Provide the table of user password information.
override define contents
root::0:0:-1:7:::
endef
$(call addon-file,shadow): private override contents := $(value contents)


# Provide a list of system shells for xterm, etc.
override define contents
/bin/bash
/bin/sh
endef
$(call addon-file,shells): private override contents := $(value contents)


# Provide a script that makes interactive sessions load system-wide settings.
override define contents
if [ -f /etc/bashrc ] ; then . /etc/bashrc ; fi
endef
$(call addon-file,user-bashrc): private override contents := $(value contents)


# Provide a file for users to customize X resources that fiddles with xterms.
override define contents
XTerm*backarrowKey: false
XTerm*background: #000000
XTerm*cursorBlink: true
XTerm*foreground: #FFFFFF
XTerm*toolBar: false
XTerm*ttyModes: erase ^?
endef
$(call addon-file,Xdefaults): private override contents := $(value contents)


# Provide a default graphical environment for X users.
$(call addon-file,xinitrc): private override contents := exec /usr/bin/wmaker


# Provide a way to combine X users' login environment and graphical startup.
override define contents
#!/bin/sh

# Load the site login environment.
if [ -r /etc/profile ] ; then . /etc/profile ; fi

# Load the user login environment.
if [ -r ~/.bash_profile ] ; then . ~/.bash_profile
elif [ -r ~/.bash_login ] ; then . ~/.bash_login
elif [ -r ~/.profile ] ; then . ~/.profile
fi

# Launch the user's preferred graphical programs.
if [ -r ~/.xinitrc ] ; then . ~/.xinitrc
elif [ -r /etc/X11/xinit/xinitrc ] ; then . /etc/X11/xinit/xinitrc
else exec /usr/bin/xterm
fi
endef
$(call addon-file,xsession): private override contents := $(value contents)
