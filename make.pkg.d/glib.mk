glib                    := glib-2.46.2
glib_url                := http://ftp.gnome.org/pub/gnome/sources/glib/2.46/$(glib).tar.xz

$(prepare-rule):
	$(call drop-rpath,configure,ltmain.sh)

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
