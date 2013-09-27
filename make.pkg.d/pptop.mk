pptop                   := pptop-0.1.1
pptop_snap              := 2013-07-01
pptop_url               := cvs://anonymous@cvs.sv.gnu.org/sources/hurdextras

prepare-pptop-rule:
	$(COPY) /usr/share/gettext/config.rpath $(pptop)/

configure-pptop-rule:
	cd $(pptop) && ./$(configure) \
		--disable-rpath \
		--enable-threads=posix \
		CPPFLAGS="`$(NCURSES_CONFIG) --cflags`" \
		LIBS="`$(NCURSES_CONFIG) --libs`"

build-pptop-rule:
	$(MAKE) -C $(pptop) all

install-pptop-rule: $(call installed,ncurses)
	$(MAKE) -C $(pptop) install \
		mkinstalldirs='mkdir -p'
	test -e $(DESTDIR)/usr/bin/top || $(SYMLINK) pptop $(DESTDIR)/usr/bin/top
