gettext                 := gettext-0.18.3.2
gettext_url             := http://ftp.gnu.org/gnu/gettext/$(gettext).tar.gz

prepare-gettext-rule:
# Seriously disable rpaths.
	$(EDIT) 's/\(need_relink\)=yes/\1=no/' $(gettext)/build-aux/ltmain.sh
	$(EDIT) 's/\(hardcode_into_libs\)=yes/\1=no/' $(gettext)/gettext-tools/configure
	$(EDIT) 's/\(hardcode_libdir_flag_spec[A-Za-z_]*\)=.*/\1=-D__LIBTOOL_NEUTERED__/' $(gettext)/gettext-tools/configure

configure-gettext-rule:
	cd $(gettext) && ./$(configure) \
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

build-gettext-rule:
	$(MAKE) -C $(gettext) all

install-gettext-rule: $(call installed,acl bzip2 gcc git gzip libcroco libunistring ncurses tar)
	$(MAKE) -C $(gettext) install
