mcron                   := mcron-1.0.8
mcron_url               := http://ftpmirror.gnu.org/mcron/$(mcron).tar.gz

prepare-mcron-rule:
	$(PATCH) -d $(mcron) < $(patchdir)/$(mcron)-fix-everything.patch

configure-mcron-rule:
	cd $(mcron) && ./$(configure) \
		--disable-no-vixie-clobber \
		--enable-debug \
		--with-allow-file=/etc/cron.allow \
		--with-deny-file=/etc/cron.deny \
		--with-pid-file=/var/run/cron.pid \
		--with-socket-file=/var/run/cron.socket \
		--with-spool-dir=/var/spool/cron \
		--with-tmp-dir=/tmp

build-mcron-rule:
ifneq ($(host),$(build))
	$(MAKE) -C $(mcron) mcron.c
	$(TOUCH) $(mcron)/mcron.1
endif
	$(MAKE) -C $(mcron) all

install-mcron-rule: $(call installed,guile)
	$(MAKE) -C $(mcron) install
	$(INSTALL) -Dpm 644 $(mcron)/dmd.scm $(DESTDIR)/etc/dmd.d/cron.scm
	$(INSTALL) -Dm 644 /dev/null $(DESTDIR)/etc/crontab
	$(INSTALL) -dm 755 $(DESTDIR)/etc/cron.d

# Provide a system service definition for "cron".
$(mcron)/dmd.scm: | $(mcron)
	$(ECHO) -e "(define cron-command\n  '"'("/usr/bin/cron"\n    "--noetc"))' > $@
	$(ECHO) -e '(make <service>\n  #:docstring "The cron service runs scheduled commands."' >> $@
	$(ECHO) -e "  #:provides '(cron crond mcron)\n  #:requires '()" >> $@
	$(ECHO) -e '  #:start (make-forkexec-constructor cron-command)\n  #:stop (make-kill-destructor))' >> $@
$(call prepared,mcron): $(mcron)/dmd.scm
