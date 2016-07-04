lsh                     := lsh-2.9.2-e9bae3
lsh_snap                := e9bae31bd385805b134f7424f99d68cd3faf137c
lsh_branch              := lsh-$(lsh_snap)-$(lsh_snap)
lsh_sha1                := 581421a4128ae469ce5dffbf9974ff78c1e66887
lsh_url                 := http://git.lysator.liu.se/lsh/lsh/repository/archive.tar.bz2?ref=$(lsh_snap)&.tar.bz2

$(prepare-rule):
	$(call apply,fhs)
	cd $(builddir) && ./.bootstrap links
	$(AUTOGEN) $(builddir) $(builddir)/argp $(builddir)/sftp $(builddir)/spki
# Take out obsolete man pages.
	$(RM) $(builddir)/doc/example.1 $(builddir)/doc/lsh_*.1 $(builddir)/doc/lsh-writekey.1
# Don't require TeX etc. for making PDFs.
	$(EDIT) 's/ lsh.pdf / /' $(builddir)/doc/Makefile.in
# System sources don't get enough entropy yet, so it will require interraction.
	$(EDIT) 's/^\(  *get_\)system/\1dev_random/' $(builddir)/src/lsh-make-seed.c

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-{agent,tcp,x11}-forward \
		--enable-ipv6 \
		--enable-srp \
		--enable-utmp \
		--with-pty \
		--with-scheme=guile \
		--with-system-argp \
		--with-x \
		\
		--disable-gss \
		--disable-kerberos \
		--disable-pam \
		--without-system-libspki \
		--without-tcp-wrappers

$(build-rule):
	$(MAKE) -C $(builddir) -j1 all

$(install-rule): $$(call installed,liboop libXau nettle)
	$(MAKE) -C $(builddir) install
	$(INSTALL) -Dpm 755 $(call addon-file,scp.sh)          $(DESTDIR)/usr/bin/scp
	$(INSTALL) -Dpm 755 $(call addon-file,sftp.sh)         $(DESTDIR)/usr/bin/sftp
	$(INSTALL) -Dpm 755 $(call addon-file,ssh.sh)          $(DESTDIR)/usr/bin/ssh
	$(INSTALL) -Dpm 644 $(call addon-file,lshd.scm)        $(DESTDIR)/etc/shepherd.d/lshd.scm
	$(INSTALL) -Dpm 644 $(call addon-file,lshd.conf)       $(DESTDIR)/etc/lshd/lshd.conf
	$(INSTALL) -Dpm 644 $(call addon-file,connection.conf) $(DESTDIR)/etc/lshd/lshd-connection.conf
	$(INSTALL) -Dpm 644 $(call addon-file,userauth.conf)   $(DESTDIR)/etc/lshd/lshd-userauth.conf
	$(INSTALL) -Dpm 644 $(call addon-file,syslog.conf)     $(DESTDIR)/etc/syslog.d/lsh.conf
	$(INSTALL) -dm 755 $(DESTDIR)/var/lib/lsh
	$(INSTALL) -Dm 600 /dev/null $(DESTDIR)/var/log/syslog/lshd.log
# Manually install man pages.
	$(INSTALL) -dm 755 $(DESTDIR)/usr/share/man/man{1,5,8}
	$(INSTALL) -pm 644 $(builddir)/doc/*.1 $(DESTDIR)/usr/share/man/man1/
	$(INSTALL) -pm 644 $(builddir)/doc/*.5 $(DESTDIR)/usr/share/man/man5/
	$(INSTALL) -pm 644 $(builddir)/doc/*.8 $(DESTDIR)/usr/share/man/man8/

# Write inline files.
$(call addon-file,connection.conf lshd.conf lshd.scm scp.sh sftp.sh ssh.sh syslog.conf userauth.conf): | $$(@D)
	$(file >$@,$(contents))
$(prepared): $(call addon-file,connection.conf lshd.conf lshd.scm scp.sh sftp.sh ssh.sh syslog.conf userauth.conf)


# Provide a default server configuration file.
override define contents
enable-core-file = no
hostkey = /etc/lshd/host-key
pid-file = /run/lshd.pid
port = 22

# Offer the following services.
service ssh-userauth = { lshd-userauth --session-id $(session_id) }

# Choose logging destinations.
use-syslog = yes
#log-file = /var/log/lshd.log

# Choose logging output.
quiet = no
verbose = yes
debug = no
trace = no
endef
$(call addon-file,lshd.conf): private override contents := $(value contents)


# Provide a default user authentication configuration file.
override define contents
allow-password = no
allow-publickey = yes
allow-root-login = no

# Offer the following services.
service ssh-connection = { lshd-connection --helper-fd $(helper_fd) }

# Choose logging destinations.
use-syslog = yes
#log-file = /var/log/lshd-userauth.log

# Choose logging output.
quiet = no
verbose = yes
debug = no
trace = no
endef
$(call addon-file,userauth.conf): private override contents := $(value contents)


# Provide a default connection configuration file.
override define contents
allow-exec = yes
allow-pty = yes
allow-tcpforward = yes
allow-session = yes
allow-shell = yes
allow-x11 = yes

# Offer the following subsystems.
#subsystem NAME = { COMMAND }

# Choose logging destinations.
use-syslog = yes
#log-file = /var/log/lshd-connection.log

# Choose logging output.
quiet = no
verbose = yes
debug = no
trace = no
endef
$(call addon-file,connection.conf): private override contents := $(value contents)


# Provide a command similar to "scp" from OpenSSH.
override define contents
#!/bin/bash -e
LCP_RSH=ssh exec ${LCP:-lcp} --force "$@"
endef
$(call addon-file,scp.sh): private override contents := $(value contents)


# Provide a command similar to "sftp" from OpenSSH.
override define contents
#!/bin/bash -e
LSFTP_RSH=ssh exec ${LSFTP:-lsftp} "$@"
endef
$(call addon-file,sftp.sh): private override contents := $(value contents)


# Provide a command similar to "ssh" from OpenSSH.
override define contents
#!/bin/bash -e
# Mimic OpenSSH defaults.
exec ${LSH:-lsh} ^
    --capture-to "$HOME/.lsh/host-acls" ^
    --no --identity "$HOME/.lsh/identity" ^
    --no-use-gateway ^
    --sloppy-host-authentication ^
    "$@"
endef
$(call addon-file,ssh.sh): private override contents := $(subst ^,\,$(value contents))


# Provide a syslog configuration to log "lshd*" tagged messages.
override define contents
! lshd
*.*					/var/log/syslog/lshd.log
! lshd-connection
*.*					/var/log/syslog/lshd.log
! lshd-userauth
*.*					/var/log/syslog/lshd.log
endef
$(call addon-file,syslog.conf): private override contents := $(value contents)


# Provide a system service definition for "lshd".
override define contents
(define lshd-command '("/usr/sbin/lshd"))
(define (lshd-start . args)
  (unless (file-exists? "/var/lib/lsh/yarrow-seed-file")
    (system* "/usr/bin/lsh-make-seed" "--quiet" "--server"))
  (unless
    (and-map file-exists? '("/etc/lshd/host-key" "/etc/lshd/host-key.pub"))
    (system* "/usr/bin/lsh-keygen" "--quiet" "--server"))
  (fork+exec-command lshd-command))
(make <service>
  #:docstring "The lshd service controls the GNU SSH server."
  #:provides '(lshd lsh ssh sshd)
  #:requires '(syslogd)
  #:start lshd-start
  #:stop (make-kill-destructor))
endef
$(call addon-file,lshd.scm): private override contents := $(value contents)
