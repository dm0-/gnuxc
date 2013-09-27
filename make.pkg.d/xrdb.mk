xrdb                    := xrdb-1.1.0
xrdb_url                := http://xorg.freedesktop.org/releases/individual/app/$(xrdb).tar.bz2

configure-xrdb-rule:
	cd $(xrdb) && ./$(configure) \
		--disable-silent-rules \
		--enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no \
		--with-cpp=/usr/bin/cpp

build-xrdb-rule:
	$(MAKE) -C $(xrdb) all

install-xrdb-rule: $(call installed,libXmu)
	$(MAKE) -C $(xrdb) install
