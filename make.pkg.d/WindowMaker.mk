WindowMaker             := WindowMaker-0.95.7
WindowMaker_sha1        := ceae84f67e056dd291199b76afd0235edda214a0
WindowMaker_url         := http://windowmaker.org/pub/source/release/$(WindowMaker).tar.gz

$(eval $(call verify-download,http://repo.or.cz/wmaker-crm.git/commitdiff_plain/9de5a27dbc57aac8af8624fdb406f3cc63e5bf39,e2b9749f0b32e66a14ac932331ea34a58b79bf20,maximize-snapping.patch))

$(prepare-rule):
	$(call apply,default-settings)
# Allow windows to be dragged to the top of the screen to maximize them.
	$(PATCH) -d $(builddir) -p1 < $(call addon-file,maximize-snapping.patch)
# Don't let it use target system directories for build system directories.
	$(EDIT) '/^\(HEADER\|LIBRARY\)_SEARCH_PATH=/d' $(builddir)/configure.ac
# Make Pango work.
	$(EDIT) '/AC_SUBST(PANGOLIBS)/iHEADER_SEARCH_PATH="$$HEADER_SEARCH_PATH $$PANGOFLAGS"' $(builddir)/configure.ac
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
