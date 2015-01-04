parted                  := parted-3.2
parted_url              := http://ftpmirror.gnu.org/parted/$(parted).tar.xz

configure-parted-rule:
	cd $(parted) && ./$(configure) \
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

build-parted-rule:
	$(MAKE) -C $(parted) all

install-parted-rule: $(call installed,e2fsprogs readline)
	$(MAKE) -C $(parted) install \
		pcdir=/usr/lib/pkgconfig
