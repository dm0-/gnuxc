WindowMaker             := WindowMaker-0.95.7
WindowMaker_url         := http://windowmaker.org/pub/source/release/$(WindowMaker).tar.gz

$(prepare-rule):
	$(call apply,default-settings)
# Don't let it use target system directories for build system directories.
	$(EDIT) '/^\(HEADER\|LIBRARY\)_SEARCH_PATH=/d' $(WindowMaker)/configure.ac
# Make Pango work.
	$(EDIT) '/AC_SUBST(PANGOLIBS)/iHEADER_SEARCH_PATH="$$HEADER_SEARCH_PATH $$PANGOFLAGS"' $(WindowMaker)/configure.ac
# Regenerate configure so build rules don't mess up its timestamp.
	$(AUTOGEN) $(WindowMaker)
	$(call drop-rpath,configure,ltmain.sh)

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-animations \
		--enable-debug \
		--enable-gif \
		--enable-jpeg \
		--enable-modelock \
		--enable-mwm-hints \
		--enable-pango \
		--enable-png \
		--enable-randr \
		--enable-shape \
		--enable-shm \
		--enable-tiff \
		--enable-usermenu \
		--enable-wmreplace \
		--enable-xdnd \
		--enable-xinerama \
		--enable-xpm \
		--with-x \
		PKGCONFIG='$(PKG_CONFIG)' \
		\
		--disable-magick \
		--disable-webp \
		--disable-xlocale \
		--disable-boehm-gc # GC assertion error in specific.c

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,gc giflib libjpeg-turbo libXft libXinerama libXmu libXpm libXrandr pango tiff xorg-server)
	$(MAKE) -C $(builddir) install
