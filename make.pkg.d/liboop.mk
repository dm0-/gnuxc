liboop                  := liboop-1.0
liboop_url              := http://download.ofb.net/liboop/$(liboop).tar.bz2

prepare-liboop-rule:
	$(RM) $(liboop)/configure

configure-liboop-rule:
	cd $(liboop) && ./$(configure) \
		--with-glib \
		--with-readline \
		--without-adns \
		--without-libwww \
		--without-tcl

build-liboop-rule:
	$(MAKE) -C $(liboop) all

install-liboop-rule: $(call installed,glib)
	$(MAKE) -C $(liboop) install
