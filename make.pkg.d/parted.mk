parted                  := parted-3.2
parted_key              := 1B49F933916A37A3F45A1812015F4DD4A70FB705
parted_url              := http://ftpmirror.gnu.org/parted/$(parted).tar.xz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--exec-prefix= \
		\
		--disable-device-mapper \
		--disable-rpath \
		--enable-assert \
		--enable-debug \
		--enable-gcc-warnings gl_cv_warn_c__Werror=no \
		--enable-threads=posix \
		--with-readline \
		--without-included-regex

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,e2fsprogs readline)
	$(MAKE) -C $(builddir) install \
		pcdir=/usr/lib/pkgconfig
