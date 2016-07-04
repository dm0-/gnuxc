shepherd                := shepherd-0.3.1
shepherd_sha1           := 702b264487968ab524b542520abcd7e2b8954ff3
shepherd_url            := http://alpha.gnu.org/gnu/shepherd/$(shepherd).tar.gz

$(prepare-rule):
	$(call apply,delay-logging)
# Don't regenerate man pages with help2man.
	$(TOUCH) $(builddir)/doc/shepherd.1

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,guile)
	$(MAKE) -C $(builddir) install
	$(INSTALL) -Dpm 755 $(call addon-file,service.sh) $(DESTDIR)/usr/sbin/service
	$(INSTALL) -Dpm 644 $(call addon-file,shepherd.scm) $(DESTDIR)/etc/shepherd.scm
	$(INSTALL) -dm 755 $(DESTDIR)/etc/shepherd.d

# Write inline files.
$(call addon-file,service.sh): | $$(@D)
	$(file >$@,$(contents))
$(prepared): $(call addon-file,service.sh)

# Provide the shepherd configuration file that is executed on system boot.
$(call addon-file,shepherd.scm): $(patchdir)/$(shepherd)-shepherd.scm | $$(@D)
	$(COPY) $< $@
$(prepared): $(call addon-file,shepherd.scm)


# Provide a compatibility "service" command from more common init systems.
override define contents
#!/bin/bash -e
daemon=${1?:Usage: service <daemon> <action>}
action=${2?:Usage: service <daemon> <action>}
shift 2
exec herd "$action" "$daemon" "$@"
endef
$(call addon-file,service.sh): private override contents := $(value contents)
