xterm                   := xterm-325
xterm_sha1              := 1775aec5db7be014d7ed367c8deb34d78376fc0e
xterm_url               := http://invisible-mirror.net/archives/xterm/$(xterm).tgz

$(configure-rule): configure := $(configure:--docdir%=)
$(configure-rule): configure := $(configure:--localedir%=)
$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-rpath-hack \
		--enable-{16,88,256,ansi}-color \
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
		--enable-regex \
		--enable-sixel-graphics \
		--enable-toolbar \
		--enable-warnings \
		--enable-{wide,16bit}-chars \
		--with-icon-theme \
		--with-icondir=/usr/share/icons \
		--with-pcre \
		--with-pkg-config \
		--with-x \
		--with-xpm \
		LIBS=-ltinfo \
		\
		--without-neXtaw \
		--without-Xaw3d \
		--without-XawPlus

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,font-adobe-100dpi font-misc-misc libXft libXaw ncurses)
	$(MAKE) -C $(builddir) install \
		DESTDIR='$(DESTDIR)'
# Manually create icon symlinks since they'd get installed in the wrong place.
	$(SYMLINK) xterm-color.png $(DESTDIR)/usr/share/icons/hicolor/48x48/apps/xterm.png
	$(SYMLINK) xterm-color.svg $(DESTDIR)/usr/share/icons/hicolor/scalable/apps/xterm.svg
