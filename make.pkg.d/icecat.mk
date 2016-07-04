icecat                  := icecat-38.8.0
icecat_sha1             := 8607b22381360fc3673803897b37fd2ba6afeeb6
icecat_url              := http://ftpmirror.gnu.org/$(subst -,/,$(icecat))-gnu2/$(icecat)-gnu2.tar.bz2

$(prepare-rule):
	$(call apply,hurd-port)
# Our GTK+ 3 doesn't use this.
	$(EDIT) 's/ atk-bridge-2.0//' $(builddir)/configure
# Ensure system extension files can be read by all users when installed.
	chmod -R go+r $(builddir)/extensions/gnu

ifneq ($(host),$(build))
$(configure-rule): configure := $(configure:--docdir%=)
$(configure-rule): configure := $(configure:--localedir%=)
$(configure-rule): configure := $(subst datarootdir,datadir,$(configure:--datadir%=))
$(configure-rule): private override export PYTHON := python
$(configure-rule):
	$(MKDIR) $(builddir)/hurd && cd $(builddir)/hurd && \
	CROSS_COMPILE=1 HOST_AR=gcc-ar HOST_CC=gcc HOST_CXX=g++ HOST_RANLIB=gcc-ranlib ../$(configure) \
		--disable-official-branding \
		--disable-strip --disable-install-strip \
		--disable-tree-freetype \
		--enable-debug-symbols \
		--enable-default-toolkit=cairo-gtk3 \
		--enable-opus \
		--enable-readline \
		--enable-system-cairo \
		--enable-system-extension-dirs \
		--enable-system-ffi \
		--enable-system-pixman \
		--enable-system-sqlite \
		--enable-webgl \
		--enable-webm \
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
		--disable-debug \
		--disable-shared-js \
		--disable-system-hunspell \
		--disable-updater \
		--without-system-libxul \
		\
		--disable-callgrind \
		--disable-jprof \
		--disable-instruments \
		--disable-profiling \
		--disable-shark \
		--disable-tests \
		--disable-valgrind \
		--disable-vtune \
		\
		--disable-accessibility \
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
		--disable-webrtc \
		--disable-webspeech \
		--disable-wmf

$(build-rule):
	$(MAKE) -C $(builddir)/hurd all

$(install-rule): $$(call installed,gtk+ icu4c libevent libvpx nss)
	$(MAKE) -C $(builddir)/hurd install
	$(INSTALL) -Dpm 644 $(call addon-file,local-settings.js) $(DESTDIR)/usr/lib/$(icecat)/defaults/pref/local-settings.js
	$(INSTALL) -Dpm 644 $(call addon-file,mozilla.cfg) $(DESTDIR)/usr/lib/$(icecat)/mozilla.cfg
	$(INSTALL) -Dpm 644 $(builddir)/browser/branding/official/default16.png $(DESTDIR)/usr/share/icons/hicolor/16x16/apps/icecat.png
	$(INSTALL) -Dpm 644 $(builddir)/browser/branding/official/default22.png $(DESTDIR)/usr/share/icons/hicolor/22x22/apps/icecat.png
	$(INSTALL) -Dpm 644 $(builddir)/browser/branding/official/default24.png $(DESTDIR)/usr/share/icons/hicolor/24x24/apps/icecat.png
	$(INSTALL) -Dpm 644 $(builddir)/browser/branding/official/default32.png $(DESTDIR)/usr/share/icons/hicolor/32x32/apps/icecat.png
	$(INSTALL) -Dpm 644 $(builddir)/browser/branding/official/content/icon48.png $(DESTDIR)/usr/share/icons/hicolor/48x48/apps/icecat.png
	$(INSTALL) -Dpm 644 $(builddir)/browser/branding/official/content/icon64.png $(DESTDIR)/usr/share/icons/hicolor/64x64/apps/icecat.png
	$(INSTALL) -Dpm 644 $(builddir)/browser/branding/official/mozicon128.png $(DESTDIR)/usr/share/icons/hicolor/128x128/apps/icecat.png
	$(INSTALL) -Dpm 644 $(builddir)/browser/branding/official/default256.png $(DESTDIR)/usr/share/icons/hicolor/256x256/apps/icecat.png
endif

# Write inline files.
$(call addon-file,local-settings.js mozilla.cfg): | $$(@D)
	$(file >$@,$(contents))
$(prepared): $(call addon-file,local-settings.js mozilla.cfg)


# Provide the settings that load customized defaults.
override define contents
pref("general.config.obscure_value", 0);
pref("general.config.filename", "mozilla.cfg");
endef
$(call addon-file,local-settings.js): private override contents := $(value contents)


# Provide a list of default preference overrides.
override define contents
// Default preference settings
defaultPref("browser.link.open_newwindow.restriction", 0);
defaultPref("browser.search.openintab", true);
defaultPref("browser.search.suggest.enabled", false);
endef
$(call addon-file,mozilla.cfg): private override contents := $(value contents)
