help2man                := help2man-1.46.4
help2man_url            := http://ftpmirror.gnu.org/help2man/$(help2man).tar.xz

configure-help2man-rule:
	cd $(help2man) && ./$(configure) \
		--enable-nls

build-help2man-rule:
	$(MAKE) -C $(help2man) all

install-help2man-rule: $(call installed,perl-gettext)
	$(MAKE) -C $(help2man) install \
		DESTDIR='$(DESTDIR)'
