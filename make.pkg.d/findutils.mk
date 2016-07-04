findutils               := findutils-4.6.0
findutils_sha1          := f18e8aaee3f3d4173a1f598001003be8706d28b0
findutils_url           := http://ftpmirror.gnu.org/findutils/$(findutils).tar.gz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-rpath \
		--enable-compiler-warnings \
		--enable-d_type-optimization \
		--enable-leaf-optimisation \
		--enable-threads=posix \
		--without-included-regex \
		\
		$(if $(DEBUG),--enable-assert,--disable-assert) \
		$(if $(DEBUG),--enable-debug,--disable-debug) \
		\
		--without-selinux

$(build-rule):
	$(MAKE) -C $(builddir) all \
		LOCATE_DB='/var/lib/misc/locatedb'

$(install-rule): $$(call installed,glibc)
	$(MAKE) -C $(builddir) install
	$(INSTALL) -Dpm 644 $(call addon-file,updatedb.cron) $(DESTDIR)/etc/cron.d/updatedb

# Provide a cron configuration to update the "locate" database daily.
$(call addon-file,updatedb.cron): | $$(@D)
# Comment out this cron job since updatedb can lock up the system.
	$(ECHO) '#' $$(( RANDOM % 60 )) $$(( RANDOM % 24 )) '* * * root /usr/bin/updatedb' > $@
$(built): $(call addon-file,updatedb.cron)
