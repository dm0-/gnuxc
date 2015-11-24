dmd                     := dmd-0.2
dmd_url                 := http://alpha.gnu.org/gnu/dmd/$(dmd).tar.gz

$(prepare-rule):
# Find the system dmdconf.scm in the configured sysconfdir.
	$(DOWNLOAD) 'http://git.savannah.gnu.org/cgit/dmd.git/patch/?id='7d14baf1034597ef5f3be24455e4544680df4b1a | $(PATCH) -d $(builddir) -p1
# Support cross-compilation.
	$(DOWNLOAD) 'http://git.savannah.gnu.org/cgit/dmd.git/patch/?id='bc00ce01834b5091dafecc6a4733303baedb06d7 | $(PATCH) -d $(builddir) -p1
# Bypass specific automake version requirements due to those patches.
	$(EDIT) $(builddir)/Makefile.in \
		-e 's/ compile /&--target="$$(host)" /' \
		-e '/%localstatedir%/{p;s/localstatedir/sysconfdir/g;}'
	$(call apply,delay-logging fhs)

$(configure-rule):
	cd $(builddir) && ./$(configure)

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,guile)
	$(MAKE) -C $(builddir) install
	$(INSTALL) -Dpm 755 $(call addon-file,service.sh) $(DESTDIR)/usr/sbin/service
	$(INSTALL) -Dpm 644 $(call addon-file,dmdconf.scm) $(DESTDIR)/etc/dmdconf.scm
	$(INSTALL) -dm 755 $(DESTDIR)/etc/dmd.d

# Write inline files.
$(call addon-file,service.sh): | $$(@D)
	$(file >$@,$(contents))
$(prepared): $(call addon-file,service.sh)

# Provide the dmd configuration file that is executed on system boot.
$(call addon-file,dmdconf.scm): $(patchdir)/$(dmd)-dmdconf.scm | $$(@D)
	$(COPY) $< $@
$(prepared): $(call addon-file,dmdconf.scm)


# Provide a compatibility "service" command from more common init systems.
override define contents
#!/bin/bash -e
daemon=${1?:Usage: service <daemon> <action>}
action=${2?:Usage: service <daemon> <action>}
shift 2
exec deco "$action" "$daemon" "$@"
endef
$(call addon-file,service.sh): private override contents := $(value contents)
