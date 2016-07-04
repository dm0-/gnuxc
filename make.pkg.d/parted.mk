parted                  := parted-3.2
parted_sha1             := 78db6ca8dd6082c5367c8446bf6f7ae044091959
parted_url              := http://ftpmirror.gnu.org/parted/$(parted).tar.xz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--exec-prefix= \
		\
		--disable-device-mapper \
		--disable-rpath \
		--disable-silent-rules \
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
