man-db                  := man-db-2.7.6.1
man-db_key              := AC0A4FF12611B6FCCF01C111393587D97D86500B
man-db_url              := http://download.savannah.gnu.org/releases/man-db/$(man-db).tar.xz

$(prepare-rule):
# Since we use --disable-setuid, remove the "man" user from the tmpfiles conf.
	$(EDIT) 's/ 2755 man / 0755 root /' $(builddir)/init/systemd/man-db.conf
# Don't put libraries in a subdirectory.
	$(EDIT) 's/^pkglib_/lib_/;s/ -rpath  *[^ ]* / /' $(builddir)/{lib,libdb}/Makefile.am
	$(RM) $(builddir)/configure

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-rpath \
		--disable-setuid \
		--enable-mandirs=GNU \
		--enable-mb-groff \
		--enable-static \
		--enable-threads=posix \
		--with-browser=icecat \
		--without-included-regex

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,gdbm groff less libpipeline)
	$(MAKE) -C $(builddir) install
	$(INSTALL) -Dpm 0644 $(call addon-file,mandb.cron) $(DESTDIR)/etc/cron.d/mandb

# Provide a cron configuration to update the "man" database daily.
$(call addon-file,mandb.cron): | $$(@D)
	$(ECHO) $$(( RANDOM % 60 )) $$(( RANDOM % 24 )) '* * * root /usr/bin/mandb' > $@
$(built): $(call addon-file,mandb.cron)
