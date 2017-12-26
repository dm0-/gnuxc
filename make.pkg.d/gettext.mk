gettext                 := gettext-0.19.8.1
gettext_key             := 462225C3B46F34879FC8496CD605848ED7E69871
gettext_url             := http://ftpmirror.gnu.org/gettext/$(gettext).tar.xz

$(prepare-rule):
# Don't make even more data directories.
	$(EDIT) '/^itsdir =/s/.(PACKAGE_SUFFIX)//' $(builddir)/gettext-tools/its/Makefile.in

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-rpath \
		--enable-acl \
		--enable-c++ \
		--enable-curses \
		--enable-libasprintf \
		--enable-openmp \
		--enable-threads=posix \
		--with-bzip2 \
		--with-emacs \
		--with-xz \
		--without-included-gettext \
		--without-included-glib \
		--without-included-libcroco \
		--without-included-libunistring \
		--without-included-libxml \
		--without-included-regex \
		\
		--disable-java

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,acl bzip2 gcc git gzip libcroco libunistring ncurses tar)
	$(MAKE) -C $(builddir) -j1 install
