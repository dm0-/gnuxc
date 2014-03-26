harfbuzz                := harfbuzz-0.9.27
harfbuzz_url            := http://www.freedesktop.org/software/harfbuzz/release/$(harfbuzz).tar.bz2

prepare-harfbuzz-rule:
# Seriously disable rpaths.
	$(EDIT) 's/\(need_relink\)=yes/\1=no/' $(harfbuzz)/ltmain.sh
	$(EDIT) 's/\(hardcode_into_libs\)=yes/\1=no/' $(harfbuzz)/configure
	$(EDIT) 's/\(hardcode_libdir_flag_spec[A-Za-z_]*\)=.*/\1=-D__LIBTOOL_NEUTERED__/' $(harfbuzz)/configure

configure-harfbuzz-rule:
	cd $(harfbuzz) && ./$(configure) \
		--disable-silent-rules \
		--enable-static \
		--with-cairo \
		--with-freetype \
		--with-glib \
		--with-gobject \
		\
		--without-coretext \
		--without-graphite2 \
		--without-icu \
		--without-uniscribe

build-harfbuzz-rule:
	$(MAKE) -C $(harfbuzz) all

install-harfbuzz-rule: $(call installed,cairo freetype glib)
	$(MAKE) -C $(harfbuzz) install
