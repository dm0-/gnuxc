man-db                  := man-db-2.7.1
man-db_url              := http://download.savannah.gnu.org/releases/man-db/$(man-db).tar.xz

configure-man-db-rule:
	cd $(man-db) && ./$(configure) \
		--disable-rpath \
		--disable-setuid \
		--disable-silent-rules \
		--enable-mandirs=GNU \
		--enable-mb-groff \
		--enable-static \
		--enable-threads=posix \
		--without-included-regex

build-man-db-rule:
	$(MAKE) -C $(man-db) all

install-man-db-rule: $(call installed,gdbm groff less libpipeline)
	$(MAKE) -C $(man-db) install
	$(INSTALL) -Dpm 644 $(man-db)/mandb.cron $(DESTDIR)/etc/cron.d/mandb

# Provide a cron configuration to update the "man" database daily.
$(man-db)/mandb.cron: | $(man-db)
	$(ECHO) $$(( RANDOM % 60 )) $$(( RANDOM % 24 )) '* * * root /usr/bin/mandb' > $@
$(call built,man-db): $(man-db)/mandb.cron
