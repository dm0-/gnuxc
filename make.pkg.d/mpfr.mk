mpfr                    := mpfr-4.0.0
mpfr_key                := 07F3DBBECC1A39605078094D980C197698C3739D
mpfr_url                := http://ftpmirror.gnu.org/mpfr/$(mpfr).tar.xz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-assert \
		--enable-shared-cache \
		--enable-thread-safe \
		--enable-warnings

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,gmp)
	$(MAKE) -C $(builddir) install
