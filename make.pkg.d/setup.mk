setup                   := setup-1

setup-protocols_url     := http://www.iana.org/assignments/protocol-numbers/protocol-numbers-1.csv
setup-services_url      := http://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.csv

$(install-rule): $$(call installed,grep grub theme tzdb)
	$(INSTALL) -dm 750 $(DESTDIR)/root
# Use an initialization script first as the system init to finish the install.
	$(INSTALL) -Dpm 755 $(builddir)/setup.sh          $(DESTDIR)/hurd/setup.sh
	$(SYMLINK) ../hurd/setup.sh                       $(DESTDIR)/sbin/init
# Set up the system configuration.
	$(INSTALL) -Dpm 644 $(builddir)/bashrc            $(DESTDIR)/etc/bashrc
	$(INSTALL) -dm  755                               $(DESTDIR)/etc/bashrc.d
	$(INSTALL) -Dpm 644 $(builddir)/fstab             $(DESTDIR)/etc/fstab
	$(INSTALL) -Dpm 644 $(builddir)/group             $(DESTDIR)/etc/group
	$(INSTALL) -Dpm 644 $(builddir)/hostname          $(DESTDIR)/etc/hostname
	$(INSTALL) -Dpm 644 $(builddir)/hosts             $(DESTDIR)/etc/hosts
	$(SYMLINK) ../usr/share/zoneinfo/America/New_York $(DESTDIR)/etc/localtime
	$(INSTALL) -Dpm 644 $(builddir)/nsswitch.conf     $(DESTDIR)/etc/nsswitch.conf
	$(INSTALL) -Dpm 644 $(builddir)/passwd            $(DESTDIR)/etc/passwd
	$(INSTALL) -Dpm 644 $(builddir)/profile           $(DESTDIR)/etc/profile
	$(INSTALL) -dm  755                               $(DESTDIR)/etc/profile.d
	$(INSTALL) -Dpm 644 $(builddir)/protocols         $(DESTDIR)/etc/protocols
	$(INSTALL) -Dpm 644 $(builddir)/resolv.conf       $(DESTDIR)/etc/resolv.conf
	$(INSTALL) -Dpm 644 $(builddir)/services          $(DESTDIR)/etc/services
	$(INSTALL) -Dpm 000 $(builddir)/shadow            $(DESTDIR)/etc/shadow
	$(INSTALL) -Dpm 644 $(builddir)/shells            $(DESTDIR)/etc/shells
	$(INSTALL) -Dpm 644 $(builddir)/bash_profile      $(DESTDIR)/etc/skel/.bash_profile
	$(INSTALL) -Dpm 644 $(builddir)/user-bashrc       $(DESTDIR)/etc/skel/.bashrc
	$(INSTALL) -dm  755                               $(DESTDIR)/etc/skel/.local/bin
	$(INSTALL) -Dpm 644 $(builddir)/Xdefaults         $(DESTDIR)/etc/skel/.Xdefaults
	$(INSTALL) -Dpm 644 $(builddir)/xinitrc           $(DESTDIR)/etc/skel/.xinitrc
	$(INSTALL) -Dpm 644 $(builddir)/xsession          $(DESTDIR)/etc/skel/.xsession
# Tack on a copy of the build system tailored for rebuilding system components.
	$(INSTALL) -Dpm 644 $(dir $(makefile))RUNTIME.md $(DESTDIR)/root/README
	$(INSTALL) -Dpm 644 $(builddir)/user-bashrc $(DESTDIR)/root/.bashrc
	$(ECHO) "alias gmake='make -C ~/wd.gnuxc -f /usr/share/gnuxc/GNUmakefile -k'" >> $(DESTDIR)/root/.bashrc
	$(INSTALL) -dm 755 $(DESTDIR)/root/.config/git
	$(ECHO) '/.gnuxc/' >> $(DESTDIR)/root/.config/git/ignore
	$(INSTALL) -dm 755 $(DESTDIR)/root/wd.gnuxc
	$(INSTALL) -dm 755 $(DESTDIR)/usr/share/gnuxc/{make.pkg.d,patches}
	$(INSTALL) -pm 644 -t $(DESTDIR)/usr/share/gnuxc/make.pkg.d $(pkgdir)/*.mk
	$(INSTALL) -pm 644 -t $(DESTDIR)/usr/share/gnuxc/patches $(patchdir)/*-*-*
	$(SED) < $(makefile) > $(DESTDIR)/usr/share/gnuxc/GNUmakefile \
		-e 's/^\(export DESTDIR *:\?=\).*/\1/' \
		-e 's/^DOWNLOAD .*/& --no-check-certificate/' \
		-e '/^packages-requested[ :]*=/iexclude ?= *' \
		-e 's/^\(installed *:\?=\).*/\1/'

# Write inline files.
$(patsubst %,$(builddir)/%,bash_profile bashrc convert-protocols.sh convert-services.sh fstab group hostname hosts nsswitch.conf passwd profile resolv.conf shadow shells user-bashrc Xdefaults xinitrc xsession): | $$(@D)
	$(file >$@,$(contents))
$(prepared): $(patsubst %,$(builddir)/%,bash_profile bashrc convert-protocols.sh convert-services.sh fstab group hostname hosts nsswitch.conf passwd profile resolv.conf shadow shells user-bashrc Xdefaults xinitrc xsession)

# Fetch the current lists of registered protocols and services in CSV format.
$(builddir)/protocols.csv: | $$(@D)
	$(DOWNLOAD) '$(setup-protocols_url)' > $@
$(builddir)/services.csv: | $$(@D)
	$(DOWNLOAD) '$(setup-services_url)' > $@
$(downloaded): $(patsubst %,$(builddir)/%.csv,protocols services)

# Convert the lists into a format that can be installed into /etc.
$(builddir)/protocols: $(patsubst %,$(builddir)/%,protocols.csv convert-protocols.sh)
	$(BASH) < $^ > $@
$(builddir)/services: $(patsubst %,$(builddir)/%,services.csv convert-services.sh)
	$(BASH) < $^ > $@
$(built): $(patsubst %,$(builddir)/%,protocols services)

# Provide a post-installation OS initialization script.
$(builddir)/setup.sh: $(patchdir)/$(setup)-setup.sh | $$(@D)
	$(COPY) $< $@
$(prepared): $(builddir)/setup.sh


# Provide a script that makes login sessions load interactive session settings.
override define contents
if [ -f ~/.bashrc ] ; then . ~/.bashrc ; fi
endef
$(builddir)/bash_profile: private override contents := $(value contents)


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
$(builddir)/bashrc: private override contents := $(value contents)


# Provide a script to convert the protocols CSV file to glibc's format.
override define contents
#!/bin/bash

echo -n '# Automatically generated from IANA protocols registry on '
date -u '+%Y-%m-%d.'

tr '\n\r' ' \n' |
sed 's/^ *//;s/,,/,-,/' |
while IFS=, read -rs decimal keyword protocol reference
do
        [[ $decimal =~ ^[0-9]+$ ]] || continue

        keyword=${keyword// /-}
        [[ $keyword =~ ^-|Reserved$ ]] && continue
        (( ${#keyword} < 8 )) && keyword+='\t'

        protocol=$(echo -n $protocol | sed 's/[ \t]\+/ /g;s/^ *" *//;s/ *" *$//;s/""/"/g')

        echo -e "${keyword,,}\t$decimal\t$keyword\t# $protocol"
done
endef
$(builddir)/convert-protocols.sh: private override contents := $(value contents)


# Provide a script to convert the services CSV file to glibc's format.
override define contents
#!/bin/bash

echo -n '# Automatically generated from IANA services registry on '
date -u '+%Y-%m-%d.'

cat - <(echo -n END,65536,,,) |
tr '\n\r' ' \n' |
sed 's/^ *//;s/,,/,-,/' |
LC_ALL=C sort -t, -k2n,2 -k3,3 |
while IFS=, read -rs name port transport description assignee
do
        [ "$name" == END ] && echo -e "${alt:-\t}# $olddesc" && continue

        name=${name##*\(} name=${name%%\)*} name=${name//\ /-}
        [ -n "$name" ] || continue

        [[ $port =~ ^[0-9]+$ ]] && [ "$transport" != - ] || continue
        (( ${#port} + ${#transport} < 7 )) && transport+='\t'

        [ "$oldport" == "$port/$transport" ] && alt+="${alt:+ }$name" && continue
        (( ${#name} <  8 )) && name+='\t'
        (( ${#alt}  >= 8 )) && alt+=' '
        (( ${#alt}  <  8 )) && alt+='\t'
        echo -en "${olddesc:+$alt# $olddesc\n}$name\t$port/$transport\t"

        alt=
        olddesc=$(echo -n $description | sed 's/[ \t]\+/ /g;s/^ *" *//;s/ *" *$//;s/""/"/g')
        oldport="$port/$transport"
done
endef
$(builddir)/convert-services.sh: private override contents := $(value contents)


# Provide a default file system table for fsck, etc.
override define contents
/dev/hd0s2		/		ext2	defaults,rw		1 1
/dev/hd0s1		/boot/efi	fat	defaults,noauto,ro	0 0
endef
$(builddir)/fstab: private override contents := $(value contents)


# Provide the table of group information.
override define contents
root:*:0:
login:*:1:
wheel:*:10:
games:*:20:
nobody:*:-1:
endef
$(builddir)/group: private override contents := $(value contents)


# Provide a default host name.
$(builddir)/hostname: private override contents := gnu


# Provide a hosts table for name lookups without DNS.
$(builddir)/hosts: private override contents := 127.0.0.1 localhost gnu


# Provide a configuration file specifying where to lookup system resources.
override define contents
group: files
hosts: files dns
passwd: files
protocols: files
services: files
shadow: files
endef
$(builddir)/nsswitch.conf: private override contents := $(value contents)


# Provide the table of user information.
override define contents
root:x:0:0:root:/root:/bin/bash
login:*:1:1:Login Pseudo-user:/etc/login:/bin/loginpr
nobody:*:-1:-1:nobody:/nowhere:/bin/false
endef
$(builddir)/passwd: private override contents := $(value contents)


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

# Configure the default path, prioritizing the root prefix for init logins.
test "$$" = 1 &&
PATH="~/.local/bin:/bin:/sbin:/usr/bin:/usr/sbin" ||
PATH="~/.local/bin:/usr/bin:/usr/sbin:/bin:/sbin"
export PATH

# Include package-specific environment settings.
for conf in /etc/profile.d/*.sh ; do . "$conf" ; done
endef
$(builddir)/profile: private override contents := $(value contents)


# Provide a default DNS client configuration using the standard QEMU address.
override define contents
domain localdomain
search localdomain
nameserver 10.0.2.3
endef
$(builddir)/resolv.conf: private override contents := $(value contents)


# Provide the table of user password information.
override define contents
root::0:0:-1:7:::
endef
$(builddir)/shadow: private override contents := $(value contents)


# Provide a list of system shells for xterm, etc.
override define contents
/bin/bash
/bin/sh
endef
$(builddir)/shells: private override contents := $(value contents)


# Provide a script that makes interactive sessions load system-wide settings.
override define contents
if [ -f /etc/bashrc ] ; then . /etc/bashrc ; fi
endef
$(builddir)/user-bashrc: private override contents := $(value contents)


# Provide a file for users to customize X resources that fiddles with xterms.
override define contents
XTerm*backarrowKey: false
XTerm*background: #000000
XTerm*cursorBlink: true
XTerm*foreground: #FFFFFF
XTerm*metaSendsEscape: true
XTerm*toolBar: false
XTerm*ttyModes: erase ^?
endef
$(builddir)/Xdefaults: private override contents := $(value contents)


# Provide a default graphical environment for X users.
$(builddir)/xinitrc: private override contents := exec /usr/bin/wmaker


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
$(builddir)/xsession: private override contents := $(value contents)
