sqlite                  := sqlite-3.9.2
sqlite_branch           := sqlite-autoconf-3090200
sqlite_url              := http://www.sqlite.org/2015/$(sqlite_branch).tar.gz

$(call configure-rule,tea): $(prepared)
	cd $(builddir)/tea && ./$(configure) \
		--disable-rpath \
		--enable-symbols \
		--enable-threads \
		--with-system-sqlite \
		--with-tcl=$(sysroot)/usr/lib \
		\
		--disable-64bit \
		--disable-64bit-vis
$(configured): $(call configured,tea)

$(call build-rule,tea): $(call configured,tea)
	$(MAKE) -C $(builddir)/tea
$(built): $(call built,tea)

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-dynamic-extensions \
		--enable-readline \
		--enable-threadsafe \
		CPPFLAGS='-DSQLITE_ENABLE_UNLOCK_NOTIFY -DSQLITE_SECURE_DELETE'

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,readline)
	$(MAKE) -C $(builddir) install
	$(MAKE) -C $(builddir)/tea install DESTDIR='$(DESTDIR)'
