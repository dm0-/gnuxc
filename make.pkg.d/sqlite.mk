sqlite                  := sqlite-3.13.0
sqlite_branch           := sqlite-autoconf-3130000
sqlite_sha1             := f6f76e310389e3f510b23826f805850449ae8653
sqlite_url              := http://www.sqlite.org/2016/$(sqlite_branch).tar.gz

$(call configure-rule,tea): $(builddir)/configure
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
		--disable-editline \
		--disable-static-shell \
		--enable-dynamic-extensions \
		--enable-fts5 \
		--enable-json1 \
		--enable-readline \
		--enable-threadsafe \
		CPPFLAGS='-DSQLITE_ENABLE_UNLOCK_NOTIFY -DSQLITE_SECURE_DELETE' \
		ac_cv_search_tgetent=-ltinfow

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,readline)
	$(MAKE) -C $(builddir) install
	$(MAKE) -C $(builddir)/tea install DESTDIR='$(DESTDIR)'
