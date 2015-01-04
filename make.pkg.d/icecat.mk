icecat                  := icecat-31.2.0
icecat_url              := http://ftpmirror.gnu.org/$(subst -,/,$(icecat))/$(icecat).tar.xz

prepare-icecat-rule:
	$(PATCH) -d $(icecat) < $(patchdir)/$(icecat)-hurd-port.patch
# These configure scripts must be created with old autoconf versions.
#	cd $(icecat) && autoreconf-2.13 --force --include-deps
#	cd $(icecat)/js/src && autoconf-2.13

ifneq ($(host),$(build))
configure-icecat-rule: configure := $(configure:--docdir%=)
configure-icecat-rule: configure := $(configure:--localedir%=)
configure-icecat-rule: configure := $(subst datarootdir,datadir,$(configure:--datadir%=))
configure-icecat-rule: export NSPR_CONFIG := /usr/bin/$(host)-nspr-config
configure-icecat-rule: export NSS_CONFIG := /usr/bin/$(host)-nss-config
configure-icecat-rule: export PYTHON := python
configure-icecat-rule:
	$(MKDIR) $(icecat)/hurd && cd $(icecat)/hurd && \
	CROSS_COMPILE=1 HOST_AR=gcc-ar HOST_CC=gcc HOST_CXX=g++ HOST_RANLIB=gcc-ranlib ../$(configure) \
		--disable-official-branding \
		--disable-strip --disable-install-strip \
		--disable-tree-freetype \
		--enable-debug --enable-debug-symbols \
		--enable-default-toolkit=cairo-gtk2 \
		--enable-readline \
		--enable-shared-js \
		--enable-system-cairo \
		--enable-system-extension-dirs \
		--enable-system-ffi \
		--enable-system-pixman \
		--enable-system-sqlite \
		--with-pthreads \
		--with-system-bz2 \
		--with-system-icu \
		--with-system-jpeg \
		--with-system-libevent \
		--with-system-libvpx \
		--with-system-nspr \
		--with-system-nss \
		--with-system-png \
		--with-system-zlib \
		--with-x \
		\
		--disable-crashreporter \
		--disable-system-hunspell \
		--disable-updater \
		--enable-opus \
		--enable-webm \
		--without-system-libxul \
		\
		--disable-callgrind \
		--disable-jprof \
		--disable-instruments \
		--disable-profiling \
		--disable-shark \
		--disable-valgrind \
		--disable-vtune \
		\
		--disable-alsa \
		--disable-dbus \
		--disable-gamepad \
		--disable-gstreamer \
		--disable-media-plugins \
		--disable-necko-wifi \
		--disable-omx-plugin \
		--disable-printing \
		--disable-pulseaudio \
		--disable-raw \
		--disable-skia \
		--disable-wave \
		--disable-webgl \
		--disable-webrtc \
		--disable-webspeech \
		--disable-wmf

build-icecat-rule:
	$(MAKE) -C $(icecat)/hurd all

install-icecat-rule: $(call installed,gtk2 icu4c libevent libvpx nss)
	$(MAKE) -C $(icecat)/hurd install
	$(INSTALL) -Dpm 644 $(icecat)/browser/branding/nightly/default16.png $(DESTDIR)/usr/share/icons/hicolor/16x16/apps/icecat.png
	$(INSTALL) -Dpm 644 $(icecat)/browser/branding/nightly/default32.png $(DESTDIR)/usr/share/icons/hicolor/32x32/apps/icecat.png
	$(INSTALL) -Dpm 644 $(icecat)/browser/branding/nightly/default48.png $(DESTDIR)/usr/share/icons/hicolor/48x48/apps/icecat.png
	$(INSTALL) -Dpm 644 $(icecat)/browser/branding/nightly/mozicon128.png $(DESTDIR)/usr/share/icons/hicolor/128x128/apps/icecat.png
endif
