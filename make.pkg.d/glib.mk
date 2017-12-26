glib                    := glib-2.54.2
glib_sha1               := 85b5d649fc3d18f8d8197bd971dfbebd94b5f96d
glib_url                := http://ftp.gnome.org/pub/gnome/sources/glib/2.54/$(glib).tar.xz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
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

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,libffi pcre)
	$(MAKE) -C $(builddir) install
