gawk                    := gawk-4.2.0
gawk_key                := D1967C63788713177D861ED7DF597815937EC0D2
gawk_url                := http://ftpmirror.gnu.org/gawk/$(gawk).tar.lz

export AWK = /usr/bin/gawk

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-rpath \
		--enable-extensions \
		--enable-lint \
		--enable-mpfr \
		--with-mpfr \
		--with-readline

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,mpfr readline)
	$(MAKE) -C $(builddir) install
