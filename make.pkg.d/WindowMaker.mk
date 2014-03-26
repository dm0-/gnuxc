WindowMaker             := WindowMaker-0.95.5
WindowMaker_url         := http://windowmaker.org/pub/source/release/$(WindowMaker).tar.gz

prepare-WindowMaker-rule:
	$(EDIT) $(WindowMaker)/WindowMaker/Defaults/WindowMaker.in \
		-e '/^  CycleWorkspaces /s/= .*;/= YES;/' \
		-e '/^  DontLinkWorkspaces /s/= .*;/= NO;/' \
		-e '/^  FocusMode /s/= .*;/= sloppy;/' \
		-e '/^  NextWorkspaceKey /s/= .*;/= "Mod1+Right";/' \
		-e '/^  PrevWorkspaceKey /s/= .*;/= "Mod1+Left";/' \
		-e '/^  WrapMenus /s/= .*;/= YES;/' \
		-e 's/^\(  OpaqueMove = \).*/\1YES;\n  OpaqueResize = YES;/'
# Don't let it use target system directories for build system directories.
	$(EDIT) '/^\(HEADER\|LIBRARY\)_SEARCH_PATH=/d' $(WindowMaker)/configure
# Seriously disable rpaths.
	$(EDIT) 's/\(need_relink\)=yes/\1=no/' $(WindowMaker)/ltmain.sh
	$(EDIT) 's/\(hardcode_into_libs\)=yes/\1=no/' $(WindowMaker)/configure
	$(EDIT) 's/\(hardcode_libdir_flag_spec[A-Za-z_]*\)=.*/\1=-D__LIBTOOL_NEUTERED__/' $(WindowMaker)/configure

configure-WindowMaker-rule:
	cd $(WindowMaker) && ./$(configure) \
		--enable-debug \
		--enable-jpeg \
		--enable-locale \
		--enable-modelock \
		--enable-png \
		--enable-shape \
		--enable-shm \
		--enable-tiff \
		--enable-usermenu \
		--enable-xpm \
		--with-x \
		\
		--disable-boehm-gc \
		--disable-gif \
		--disable-xinerama \
		--disable-xrandr
# GC assertion error in specific.c

build-WindowMaker-rule:
	$(MAKE) -C $(WindowMaker) all \
		CPPFLAGS='-D_XOPEN_SOURCE=600 -DDEBUG' \
		CFLAGS='$(CFLAGS)' \
		LDFLAGS='$(LDFLAGS)'

install-WindowMaker-rule: $(call installed,gc libjpeg-turbo libXft libXmu libXpm tiff xorg-server)
	$(MAKE) -C $(WindowMaker) install
