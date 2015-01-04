glib                    := glib-2.42.1
glib_url                := http://ftp.gnome.org/pub/gnome/sources/glib/2.42/$(glib).tar.xz

prepare-glib-rule:
# Seriously disable rpaths.
	$(EDIT) 's/\(need_relink\)=yes/\1=no/' $(glib)/ltmain.sh
	$(EDIT) 's/\(hardcode_into_libs\)=yes/\1=no/' $(glib)/configure
	$(EDIT) 's/\(hardcode_libdir_flag_spec[A-Za-z_]*\)=.*/\1=-D__LIBTOOL_NEUTERED__/' $(glib)/configure

configure-glib-rule:
	cd $(glib) && ./$(configure) \
		--disable-modular-tests \
		--disable-silent-rules \
		--enable-debug \
		--enable-gc-friendly \
		--enable-static \
		--enable-xattr \
		--with-pcre=system \
		--with-threads=posix \
		\
		--disable-fam \
		--disable-libelf \
		--disable-selinux

build-glib-rule:
	$(MAKE) -C $(glib) all

install-glib-rule: $(call installed,libffi pcre)
	$(MAKE) -C $(glib) install
