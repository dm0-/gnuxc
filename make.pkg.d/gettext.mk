gettext                 := gettext-0.19.6
gettext_url             := http://ftpmirror.gnu.org/gettext/$(gettext).tar.xz

$(prepare-rule):
	$(call drop-rpath,gettext-tools/configure,build-aux/ltmain.sh)

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
