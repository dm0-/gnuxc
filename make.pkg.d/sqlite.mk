sqlite                  := sqlite-3.8.7.4
sqlite_branch           := sqlite-autoconf-3080704
sqlite_url              := http://www.sqlite.org/2014/$(sqlite_branch).tar.gz

configure-sqlite-rule:
	cd $(sqlite) && ./$(configure) \
		--enable-dynamic-extensions \
		--enable-readline \
		--enable-threadsafe \
		CPPFLAGS='-DSQLITE_ENABLE_UNLOCK_NOTIFY -DSQLITE_SECURE_DELETE'

build-sqlite-rule:
	$(MAKE) -C $(sqlite) all

install-sqlite-rule: $(call installed,readline)
	$(MAKE) -C $(sqlite) install
