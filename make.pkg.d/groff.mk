groff                   := groff-1.22.3
groff_url               := http://ftpmirror.gnu.org/groff/$(groff).tar.gz

$(prepare-rule):
	$(call apply,relative-links)

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-rpath \
		--with-appresdir='/usr/share/X11/app-defaults' \
		--with-awk='$(AWK)' \
		--with-grofferdir='/usr/share/groff/$(groff:groff-%=%)/groffer' \
		--with-x

$(build-rule):
	$(MAKE) -C $(builddir) -j1 all \
		GROFFBIN=/usr/bin/groff \
		TROFFBIN=/usr/bin/troff

$(install-rule): $$(call installed,libXaw readline)
	$(MAKE) -C $(builddir) install \
		docdir='$$(datarootdir)/doc/groff'
	test -e $(DESTDIR)/usr/bin/gtbl || $(SYMLINK) tbl $(DESTDIR)/usr/bin/gtbl
