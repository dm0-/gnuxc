zile                    := zile-2.4.11
zile_url                := http://ftpmirror.gnu.org/zile/$(zile).tar.gz

ifneq ($(host),$(build))
configure-zile-rule: export HELP2MAN = /bin/true
endif
configure-zile-rule:
	cd $(zile) && ./$(configure) \
		--disable-rpath \
		--disable-silent-rules \
		--enable-acl \
		--enable-gcc-warnings \
		--enable-threads=posix \
		--with-ncursesw \
		--with-perl='$(PERL)' \
		--without-included-regex \
		LIBS='-ltinfo'

build-zile-rule:
	$(MAKE) -C $(zile) all \
		CPPFLAGS="`$(NCURSESW_CONFIG) --cflags`"

install-zile-rule: $(call installed,acl gc ncurses)
	$(MAKE) -C $(zile) install
	$(INSTALL) -Dpm 644 $(zile)/zile-user $(DESTDIR)/etc/skel/.zile
	$(INSTALL) -dm 755 $(DESTDIR)/etc/skel/.local/share/zile/backups
	test -e $(DESTDIR)/usr/bin/emacs || $(SYMLINK) zile $(DESTDIR)/usr/bin/emacs

# Provide default user settings for Zile.
$(zile)/zile-user: | $(zile)
	$(ECHO) '(setq backup-directory "~/.local/share/zile/backups")' > $@
$(call prepared,zile): $(zile)/zile-user
