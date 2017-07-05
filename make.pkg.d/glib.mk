glib                    := glib-2.52.3
glib_sha1               := 9e31cce788d018894e6e0b1350263bc11b41cff8
glib_url                := http://ftp.gnome.org/pub/gnome/sources/glib/2.52/$(glib).tar.xz

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
