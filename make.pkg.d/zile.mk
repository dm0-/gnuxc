zile                    := zile-2.4.14
zile_key                := 24093F016FFE8602EF449BB84C8EF3DA3FD37230
zile_url                := http://ftpmirror.gnu.org/zile/$(zile).tar.gz

ifneq ($(host),$(build))
$(configure-rule): private override export HELP2MAN = /bin/true
endif
$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-rpath \
		--enable-acl \
		--enable-gcc-warnings \
		--enable-threads=posix \
		--with-ncursesw \
		--with-perl='$(PERL)' \
		--without-included-regex \
		LIBS='-ltinfow' \
		\
		$(if $(DEBUG),--enable-debug,--disable-debug)

$(build-rule):
	$(MAKE) -C $(builddir) all \
		CPPFLAGS="`$(NCURSESW_CONFIG) --cflags`"

$(install-rule): $$(call installed,acl gc ncurses)
	$(MAKE) -C $(builddir) install
	$(INSTALL) -Dpm 0644 $(call addon-file,zile-user) $(DESTDIR)/etc/skel/.zile
	$(INSTALL) -dm 0755 $(DESTDIR)/etc/skel/.local/share/zile/backups
	test -e $(DESTDIR)/usr/bin/emacs || $(SYMLINK) zile $(DESTDIR)/usr/bin/emacs

# Provide default user settings for Zile.
$(call addon-file,zile-user): | $$(@D)
	$(ECHO) '(setq backup-directory "~/.local/share/zile/backups")' > $@
$(prepared): $(call addon-file,zile-user)
