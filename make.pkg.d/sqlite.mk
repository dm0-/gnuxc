sqlite                  := sqlite-3.8.0.2
sqlite_branch           := sqlite-autoconf-3080002
sqlite_url              := http://www.sqlite.org/2013/$(sqlite_branch).tar.gz

configure-sqlite-rule:
	cd $(sqlite) && ./$(configure) \
		--enable-dynamic-extensions \
		--enable-readline \
		--enable-threadsafe

build-sqlite-rule:
	$(MAKE) -C $(sqlite) all

install-sqlite-rule: $(call installed,readline)
	$(MAKE) -C $(sqlite) install
