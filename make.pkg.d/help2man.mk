help2man                := help2man-1.47.3
help2man_url            := http://ftpmirror.gnu.org/help2man/$(help2man).tar.xz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-nls

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,perl-gettext)
	$(MAKE) -C $(builddir) install \
		DESTDIR='$(DESTDIR)'
