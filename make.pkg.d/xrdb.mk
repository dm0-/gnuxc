xrdb                    := xrdb-1.1.0
xrdb_sha1               := b95ae53b767ee7b56baa55fc78eb9c0b9e5ccd29
xrdb_url                := http://xorg.freedesktop.org/releases/individual/app/$(xrdb).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules \
		--enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no \
		--with-cpp=/usr/bin/cpp

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,libXmu)
	$(MAKE) -C $(builddir) install
