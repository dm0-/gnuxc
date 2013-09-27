zile                    := zile-2.4.9
zile_url                := http://ftp.gnu.org/gnu/zile/$(zile).tar.gz

configure-zile-rule:
	cd $(zile) && ./$(configure) \
		--disable-silent-rules \
		--enable-acl \
		--enable-gcc-warnings gl_cv_warn_c__fmudflap=no \
		--with-ncursesw \
		--with-perl='$(PERL)' \
		--without-included-regex \
		LIBS='-ltinfo'

build-zile-rule:
	$(MAKE) -C $(zile) all \
		CPPFLAGS="`$(NCURSESW_CONFIG) --cflags`" \
		CURSES_LIB="`$(NCURSESW_CONFIG) --libs`" \
		man_MANS=

install-zile-rule: $(call installed,acl gc ncurses)
	$(MAKE) -C $(zile) install \
		man_MANS=
	test -e $(DESTDIR)/usr/bin/emacs || $(SYMLINK) zile $(DESTDIR)/usr/bin/emacs
