parted                  := parted-3.1
parted_url              := http://ftp.gnu.org/gnu/parted/$(parted).tar.xz

configure-parted-rule:
	cd $(parted) && ./$(configure) \
		--exec-prefix= \
		\
		--disable-device-mapper \
		--disable-rpath \
		--disable-silent-rules \
		--enable-debug \
		--enable-gcc-warnings gl_cv_warn__Werror=no \
		--enable-threads=posix \
		--with-readline \
		--without-included-regex

build-parted-rule:
	$(MAKE) -C $(parted) all

install-parted-rule: $(call installed,e2fsprogs readline)
	$(MAKE) -C $(parted) install \
		pcdir=/usr/lib/pkgconfig
