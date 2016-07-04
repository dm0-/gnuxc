liboop                  := liboop-1.0
liboop_sha1             := 9c58eeb8b08ba455ac379970cd7df02c48d111d1
liboop_url              := http://download.ofb.net/liboop/$(liboop).tar.bz2

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
