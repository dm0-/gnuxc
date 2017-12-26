xterm                   := xterm-330
xterm_key               := C52048C0C0748FEE227D47A2702353E0F7E48EDB
xterm_url               := http://invisible-mirror.net/archives/xterm/$(xterm).tgz
xterm_sig               := $(xterm_url).asc

$(prepare-rule):
	$(call apply,pcre2)
# Drop this ioctl or xterm can't start.
	$(EDIT) /TIOCLSET,/,/ERROR_TIOCLSET/d $(builddir)/main.c

$(configure-rule): configure := $(configure:--docdir%=)
$(configure-rule): configure := $(configure:--localedir%=)
$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-rpath-hack \
		--enable-{16,88,256,ansi}-color \
		--enable-dabbrev \
		--enable-double-buffer \
		--enable-exec-xterm \
		--enable-freetype \
		--enable-{hp,sco,sun}-fkeys \
		--enable-load-vt-fonts \
		--enable-logging \
		--enable-logfile-exec \
		--enable-luit \
		--enable-narrowproto \
		--enable-readline-mouse \
		--enable-rectangles \
		--enable-regex \
		--enable-{regis,sixel}-graphics \
		--enable-screen-dumps \
		--enable-toolbar \
		--enable-warnings \
		--enable-{wide,16bit}-chars \
		--with-freetype-config=auto \
		--with-icon-theme \
		--with-icondir=/usr/share/icons \
		--with-pcre2 \
		--with-pkg-config='$(firstword $(PKG_CONFIG))' \
		--with-x \
		--with-xpm \
		LIBS=-ltinfo \
		\
		--without-neXtaw \
		--without-Xaw3d \
		--without-XawPlus

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,font-adobe-100dpi font-misc-misc libXft libXaw ncurses pcre2)
	$(MAKE) -C $(builddir) install \
		DESTDIR='$(DESTDIR)'
# Manually create icon symlinks since they'd get installed in the wrong place.
	$(SYMLINK) xterm-color.png $(DESTDIR)/usr/share/icons/hicolor/48x48/apps/xterm.png
	$(SYMLINK) xterm-color.svg $(DESTDIR)/usr/share/icons/hicolor/scalable/apps/xterm.svg
