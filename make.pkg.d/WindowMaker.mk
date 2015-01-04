WindowMaker             := WindowMaker-0.95.6
WindowMaker_url         := http://windowmaker.org/pub/source/release/$(WindowMaker).tar.gz

prepare-WindowMaker-rule:
	$(PATCH) -d $(WindowMaker) < $(patchdir)/$(WindowMaker)-default-settings.patch
	$(PATCH) -d $(WindowMaker) < $(patchdir)/$(WindowMaker)-update-giflib.patch
# Don't let it use target system directories for build system directories.
	$(EDIT) '/^\(HEADER\|LIBRARY\)_SEARCH_PATH=/d' $(WindowMaker)/configure.ac
# Regenerate configure so build rules don't mess up its timestamp.
	$(AUTOGEN) $(WindowMaker)
# Seriously disable rpaths.
	$(EDIT) 's/\(need_relink\)=yes/\1=no/' $(WindowMaker)/ltmain.sh
	$(EDIT) 's/\(hardcode_into_libs\)=yes/\1=no/' $(WindowMaker)/configure
	$(EDIT) 's/\(hardcode_libdir_flag_spec[A-Za-z_]*\)=.*/\1=-D__LIBTOOL_NEUTERED__/' $(WindowMaker)/configure

configure-WindowMaker-rule:
	cd $(WindowMaker) && ./$(configure) \
		--enable-debug \
		--enable-gif \
		--enable-jpeg \
		--enable-locale \
		--enable-modelock \
		--enable-png \
		--enable-randr \
		--enable-shape \
		--enable-shm \
		--enable-tiff \
		--enable-usermenu \
		--enable-xdnd \
		--enable-xinerama \
		--enable-xpm \
		--with-x \
		PKGCONFIG='$(PKG_CONFIG)' \
		\
		--disable-magick \
		--disable-webp \
		--disable-boehm-gc # GC assertion error in specific.c

build-WindowMaker-rule:
	$(MAKE) -C $(WindowMaker) all

install-WindowMaker-rule: $(call installed,gc giflib libjpeg-turbo libXft libXinerama libXmu libXpm libXrandr tiff xorg-server)
	$(MAKE) -C $(WindowMaker) install
