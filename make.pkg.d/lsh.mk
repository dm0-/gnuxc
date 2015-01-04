lsh                     := lsh-2.1
lsh_url                 := http://ftpmirror.gnu.org/lsh/$(lsh).tar.gz

prepare-lsh-rule:
	$(PATCH) -d $(lsh) < $(patchdir)/$(lsh)-fhs.patch

configure-lsh-rule:
	cd $(lsh) && ./$(configure)

build-lsh-rule:
	$(MAKE) -C $(lsh) all

install-lsh-rule: $(call installed,liboop nettle)
	$(MAKE) -C $(lsh) install
	$(INSTALL) -Dpm 600 $(lsh)/yarrow-seed-file $(DESTDIR)/var/lib/lsh/yarrow-seed-file
	$(INSTALL) -Dpm 644 $(lsh)/bashrc.sh $(DESTDIR)/etc/bashrc.d/lsh.sh
	$(INSTALL) -Dpm 644 $(lsh)/dmd.scm $(DESTDIR)/etc/dmd.d/lshd.scm
	$(INSTALL) -Dpm 644 $(lsh)/syslog.conf $(DESTDIR)/etc/syslog.d/lsh.conf

# Provide a bash alias that is closer to "ssh" from more common SSH clients.
$(lsh)/bashrc.sh: | $(lsh)
	$(ECHO) "alias ssh='lsh --sloppy-host-authentication --capture-to ~/.lsh/host-acls'" > $@
$(call prepared,lsh): $(lsh)/bashrc.sh

# Provide a system service definition for "lshd".
$(lsh)/dmd.scm: | $(lsh)
	$(ECHO) -e "(define lshd-command\n  '"'("/usr/sbin/lshd"\n    "--pid-file=/var/run/lshd.pid"))' > $@
	$(ECHO) -e "(define (lshd-start . args)\n  (unless (and-map file-exists? '"'("/etc/lsh_host_key" "/etc/lsh_host_key.pub"))' >> $@
	$(ECHO) -e '    (system "/usr/bin/lsh-keygen --server | /usr/bin/lsh-writekey --server"))\n  (fork+exec-command lshd-command))' >> $@
	$(ECHO) -e '(make <service>\n  #:docstring "The lshd service controls the GNU SSH server."' >> $@
	$(ECHO) -e "  #:provides '(lshd lsh ssh sshd)\n  #:requires '()\n  #:start lshd-start\n  #:stop (make-kill-destructor))" >> $@
$(call prepared,lsh): $(lsh)/dmd.scm

# Provide a syslog configuration to log "lshd" tagged messages.
$(lsh)/syslog.conf: | $(lsh)
	$(ECHO) -e '! lshd\n*.*\t\t\t\t\t/var/log/lshd.log' > $@
$(call prepared,lsh): $(lsh)/syslog.conf

# Provide a random seed file so it doesn't need to be generated at runtime.
$(lsh)/yarrow-seed-file: | $(lsh)
	dd if=/dev/random of=$@ bs=1 count=32
$(call built,lsh): $(lsh)/yarrow-seed-file
