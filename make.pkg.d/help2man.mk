help2man                := help2man-1.47.4
help2man_sha1           := 5bc859694eb7b8f7196514bf42c449b7dd6cfc27
help2man_url            := http://ftpmirror.gnu.org/help2man/$(help2man).tar.xz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-nls

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,perl-Locale-gettext)
	$(MAKE) -C $(builddir) install \
		DESTDIR='$(DESTDIR)'
