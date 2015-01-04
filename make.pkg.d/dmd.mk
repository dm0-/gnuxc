dmd                     := dmd-0.2
dmd_url                 := http://alpha.gnu.org/gnu/dmd/$(dmd).tar.gz

prepare-dmd-rule:
# Find the system dmdconf.scm in the configured sysconfdir.
	$(DOWNLOAD) 'http://git.savannah.gnu.org/cgit/dmd.git/patch/?id=7d14baf1034597ef5f3be24455e4544680df4b1a' | $(PATCH) -d $(dmd) -p1
# Support cross-compilation.
	$(DOWNLOAD) 'http://git.savannah.gnu.org/cgit/dmd.git/patch/?id=bc00ce01834b5091dafecc6a4733303baedb06d7' | $(PATCH) -d $(dmd) -p1
# Bypass specific automake version requirements due to those patches.
	$(EDIT) $(dmd)/Makefile.in \
		-e 's/ compile /&--target="$$(host)" /' \
		-e '/%localstatedir%/{p;s/localstatedir/sysconfdir/g;}'
	$(PATCH) -d $(dmd) < $(patchdir)/$(dmd)-delay-logging.patch

configure-dmd-rule:
	cd $(dmd) && ./$(configure)

build-dmd-rule:
	$(MAKE) -C $(dmd) all

install-dmd-rule: $(call installed,guile)
	$(MAKE) -C $(dmd) install
	$(INSTALL) -Dpm 755 $(dmd)/service.sh $(DESTDIR)/usr/sbin/service
	$(INSTALL) -Dpm 644 $(dmd)/dmdconf.scm $(DESTDIR)/etc/dmdconf.scm
	$(INSTALL) -dm 755 $(DESTDIR)/etc/dmd.d

# Provide the dmd configuration file that is executed on system boot.
$(dmd)/dmdconf.scm: $(patchdir)/$(dmd)-dmdconf.scm | $(dmd)
	$(COPY) $< $@
$(call prepared,dmd): $(dmd)/dmdconf.scm

# Provide a compatibility "service" command from more common init systems.
$(dmd)/service.sh: | $(dmd)
	$(ECHO) '#!$(BASH) -e' > $@
	$(ECHO) 'daemon=$${1?:Usage: service <daemon> <action>}' >> $@
	$(ECHO) 'action=$${2?:Usage: service <daemon> <action>}' >> $@
	$(ECHO) 'shift 2' >> $@
	$(ECHO) 'exec deco "$$action" "$$daemon" "$$@"' >> $@
$(call prepared,dmd): $(dmd)/service.sh
