findutils               := findutils-4.5.14
findutils_url           := http://alpha.gnu.org/gnu/findutils/$(findutils).tar.gz

configure-findutils-rule:
	cd $(findutils) && ./$(configure) \
		--disable-rpath \
		--enable-assert \
		--enable-compiler-warnings \
		--enable-debug \
		--enable-d_type-optimization \
		--enable-leaf-optimisation \
		--enable-threads=posix \
		--without-included-regex \
		\
		--without-selinux

build-findutils-rule:
	$(MAKE) -C $(findutils) all \
		LOCATE_DB='/var/lib/misc/locatedb'

install-findutils-rule: $(call installed,glibc)
	$(MAKE) -C $(findutils) install
	$(INSTALL) -Dpm 644 $(findutils)/updatedb.cron $(DESTDIR)/etc/cron.d/updatedb

# Provide a cron configuration to update the "locate" database daily.
$(findutils)/updatedb.cron: | $(findutils)
	$(ECHO) $$(( RANDOM % 60 )) $$(( RANDOM % 24 )) '* * * root /usr/bin/updatedb' > $@
$(call built,findutils): $(findutils)/updatedb.cron
