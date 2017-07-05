liboop                  := liboop-1.0.1
liboop_sha1             := 538be0d7a9fb7e9d88eb89bb15b65d6d7d9dcaa3
liboop_url              := http://ftp.lysator.liu.se/pub/liboop/$(liboop).tar.gz

$(prepare-rule):
# Rewrite the old configure script to support a newer TCL version.
	$(EDIT) '/for version in /s/ 8.4 / 8.6&/' $(builddir)/configure.ac
	$(RM) $(builddir)/configure

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--with-glib \
		--with-readline \
		--with-tcl \
		--without-adns \
		--without-libwww

$(build-rule):
	$(MAKE) -C $(builddir) -j1 all

$(install-rule): $$(call installed,glib tcl)
	$(MAKE) -C $(builddir) install
