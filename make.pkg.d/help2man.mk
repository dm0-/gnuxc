help2man                := help2man-1.47.5
help2man_key            := 87EA44D150D89615E39A3FEEF0DC8E00B28C5995
help2man_url            := http://ftpmirror.gnu.org/help2man/$(help2man).tar.xz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-nls

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,perl-Locale-gettext)
	$(MAKE) -C $(builddir) install \
		DESTDIR='$(DESTDIR)'
