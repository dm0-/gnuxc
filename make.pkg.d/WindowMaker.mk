WindowMaker             := WindowMaker-0.95.8
WindowMaker_sha1        := fd59e3cb07071bd70359eef427ff12eb9cfe4641
WindowMaker_url         := http://windowmaker.org/pub/source/release/$(WindowMaker).tar.gz

$(prepare-rule):
	$(call apply,default-settings)
# Don't let it use target system directories for build system directories.
	$(EDIT) "/^\(inc\|lib\)_search_path='-/d" $(builddir)/configure.ac
# Update ImageMagick to version 7.
	$(EDIT) 's,wand/\(magick_wand\|MagickWand\).h,MagickWand/MagickWand.h,' $(builddir)/m4/wm_imgfmt_check.m4 $(builddir)/wrlib/load_magick.c
# Regenerate configure so build rules don't mess up its time stamp.
	$(RM) $(builddir)/configure

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-animations \
		--enable-boehm-gc \
		--enable-debug \
		--enable-gif \
		--enable-jpeg \
		--enable-magick \
		--enable-modelock \
		--enable-mwm-hints \
		--enable-pango \
		--enable-png \
		--enable-randr \
		--enable-shape \
		--enable-shm \
		--enable-tiff \
		--enable-usermenu \
		--enable-webp \
		--enable-wmreplace \
		--enable-xdnd \
		--enable-xinerama \
		--enable-xpm \
		--with-x \
		PKGCONFIG='$(PKG_CONFIG)' \
		\
		--disable-xlocale \
		--disable-boehm-gc # This causes horrible crashes.

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,gc ImageMagick libXrandr xorg-server)
	$(MAKE) -C $(builddir) install
