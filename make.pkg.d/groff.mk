groff                   := groff-1.22.2
groff_url               := http://ftp.gnu.org/gnu/groff/$(groff).tar.gz

prepare-groff-rule:
	$(PATCH) -d $(groff) < $(patchdir)/$(groff)-relative-links.patch

configure-groff-rule:
	cd $(groff) && ./$(configure) \
		--disable-rpath \
		--with-appresdir='/usr/share/X11/app-defaults' \
		--with-awk='$(AWK)' \
		--with-grofferdir='/usr/share/groff/$(groff:groff-%=%)/groffer' \
		--with-x

build-groff-rule:
	$(MAKE) -C $(groff) all \
		GROFFBIN=/usr/bin/groff \
		TROFFBIN=/usr/bin/troff

install-groff-rule: $(call installed,libXaw readline)
	$(MAKE) -C $(groff) install
	test -e $(DESTDIR)/usr/bin/gtbl || $(SYMLINK) tbl $(DESTDIR)/usr/bin/gtbl
