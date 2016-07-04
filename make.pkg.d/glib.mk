glib                    := glib-2.48.1
glib_sha1               := d59b6daf51dff21c6327734a99f1fb6c5328bcf9
glib_url                := http://ftp.gnome.org/pub/gnome/sources/glib/2.48/$(glib).tar.xz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
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

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,libffi pcre)
	$(MAKE) -C $(builddir) install
