shepherd                := shepherd-0.3.2
shepherd_key            := 3CE464558A84FDC69DB40CFB090B11993D9AEBB5
shepherd_url            := http://alpha.gnu.org/gnu/shepherd/$(shepherd).tar.gz

$(prepare-rule):
	$(call apply,delay-logging)
	$(EDIT) '/ development files /s/as_fn_error/echo/' $(builddir)/configure
# Don't regenerate man pages with help2man.
	$(TOUCH) $(builddir)/doc/shepherd.1

$(configure-rule):
	cd $(builddir) && ./$(configure)

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,guile)
	$(MAKE) -C $(builddir) install
	$(INSTALL) -Dpm 0644 $(call addon-file,shepherd.scm) $(DESTDIR)/etc/shepherd.scm
	$(INSTALL) -dm 0755 $(DESTDIR)/etc/shepherd.d
	$(INSTALL) -Dm 0644 /dev/null $(DESTDIR)/var/log/shepherd.log

# Provide the shepherd configuration file that is executed on system boot.
$(call addon-file,shepherd.scm): $(patchdir)/$(shepherd)-shepherd.scm | $$(@D)
	$(COPY) $< $@
$(prepared): $(call addon-file,shepherd.scm)
