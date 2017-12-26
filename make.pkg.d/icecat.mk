icecat                  := icecat-52.3.0
icecat_key              := A57369A8BABC2542B5A0368C3C76EED7D7E04784
icecat_url              := http://ftpmirror.gnu.org/$(subst -,/,$(icecat))/$(icecat)-gnu1.tar.bz2

$(prepare-rule):
	$(call apply,hurd-port)
# Ensure system extension files can be read by all users when installed.
	chmod -R go+r $(builddir)/extensions/gnu

ifneq ($(host),$(build))
$(configure-rule): configure := $(configure:--host%=)
$(configure-rule): configure := $(configure:--build%=--host%)
$(configure-rule): configure := $(configure:--disable-silent-rules%=)
$(configure-rule): configure := $(configure:--bindir%=)
$(configure-rule): configure := $(subst datarootdir,datadir,$(configure:--datadir%=))
$(configure-rule): configure := $(configure:--docdir%=)
$(configure-rule): configure := $(configure:--exec-prefix%=)
$(configure-rule): configure := $(configure:--infodir%=)
$(configure-rule): configure := $(configure:--libexecdir%=)
$(configure-rule): configure := $(configure:--localedir%=)
$(configure-rule): configure := $(configure:--localstatedir%=)
$(configure-rule): configure := $(configure:--mandir%=)
$(configure-rule): configure := $(configure:--oldincludedir%=)
$(configure-rule): configure := $(configure:--program-prefix%=)
$(configure-rule): configure := $(configure:--sbindir%=)
$(configure-rule): configure := $(configure:--sharedstatedir%=)
$(configure-rule): configure := $(configure:--sysconfdir%=)
$(configure-rule): private override export PYTHON := python
$(configure-rule):
	$(MKDIR) $(builddir)/hurd && cd $(builddir)/hurd && \
	CROSS_COMPILE=1 HOST_AR=gcc-ar HOST_CC=gcc HOST_CXX=g++ HOST_RANLIB=gcc-ranlib PKG_CONFIG=$(firstword $(PKG_CONFIG)) ../$(configure) \
		--disable-strip --disable-install-strip \
		--enable-debug-symbols \
		--enable-default-toolkit=cairo-gtk3 \
		--enable-official-branding \
		--enable-pulseaudio \
		--enable-readline \
		--enable-system-cairo \
		--enable-system-extension-dirs \
		--enable-system-pixman \
		--enable-system-sqlite \
		--with-pthreads \
		--with-system-bz2 \
		--with-system-ffi \
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
		\
		--disable-callgrind \
		--disable-jprof \
		--disable-instruments \
		--disable-profiling \
		--disable-tests \
		--disable-valgrind \
		--disable-vtune \
		\
		--disable-accessibility \
		--disable-alsa \
		--disable-dbus \
		--disable-gamepad \
		--disable-gconf \
		--disable-necko-wifi \
		--disable-omx-plugin \
		--disable-printing \
		--disable-raw \
		--disable-skia \
		--disable-webrtc \
		--disable-webspeech \
		--disable-wmf

$(build-rule):
	$(MAKE) -C $(builddir)/hurd all

$(install-rule): $$(call installed,gtk+ icu4c libevent libvpx nss pulseaudio)
	$(MAKE) -C $(builddir)/hurd install
	$(INSTALL) -Dpm 0644 $(call addon-file,local-settings.js) $(DESTDIR)/usr/lib/$(icecat)/defaults/pref/local-settings.js
	$(INSTALL) -Dpm 0644 $(call addon-file,mozilla.cfg) $(DESTDIR)/usr/lib/$(icecat)/mozilla.cfg
	$(INSTALL) -Dpm 0644 $(builddir)/browser/branding/official/default16.png $(DESTDIR)/usr/share/icons/hicolor/16x16/apps/icecat.png
	$(INSTALL) -Dpm 0644 $(builddir)/browser/branding/official/default22.png $(DESTDIR)/usr/share/icons/hicolor/22x22/apps/icecat.png
	$(INSTALL) -Dpm 0644 $(builddir)/browser/branding/official/default24.png $(DESTDIR)/usr/share/icons/hicolor/24x24/apps/icecat.png
	$(INSTALL) -Dpm 0644 $(builddir)/browser/branding/official/default32.png $(DESTDIR)/usr/share/icons/hicolor/32x32/apps/icecat.png
	$(INSTALL) -Dpm 0644 $(builddir)/browser/branding/official/content/icon48.png $(DESTDIR)/usr/share/icons/hicolor/48x48/apps/icecat.png
	$(INSTALL) -Dpm 0644 $(builddir)/browser/branding/official/content/icon64.png $(DESTDIR)/usr/share/icons/hicolor/64x64/apps/icecat.png
	$(INSTALL) -Dpm 0644 $(builddir)/browser/branding/official/mozicon128.png $(DESTDIR)/usr/share/icons/hicolor/128x128/apps/icecat.png
	$(INSTALL) -Dpm 0644 $(builddir)/browser/branding/official/default256.png $(DESTDIR)/usr/share/icons/hicolor/256x256/apps/icecat.png
# Save nearly a gigabyte of disk space from a duplicate library.
	$(LINK) $(DESTDIR)/usr/lib/$(icecat)/libxul.so $(DESTDIR)/usr/lib/$(icecat:icecat-%=icecat-devel-%/sdk/lib)/libxul.so
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
