xterm                   := xterm-314
xterm_url               := ftp://invisible-island.net/xterm/$(xterm).tgz

configure-xterm-rule: configure := $(configure:--docdir%=)
configure-xterm-rule: configure := $(configure:--localedir%=)
configure-xterm-rule:
	cd $(xterm) && ./$(configure) \
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
		--with-pcre \
		--with-pkg-config \
		--with-x \
		--with-xpm \
		LIBS=-ltinfo \
		\
		--without-neXtaw \
		--without-Xaw3d \
		--without-XawPlus

build-xterm-rule:
	$(MAKE) -C $(xterm) all

install-xterm-rule: $(call installed,libXft libXaw ncurses)
	$(MAKE) -C $(xterm) install \
		DESTDIR='$(DESTDIR)'
