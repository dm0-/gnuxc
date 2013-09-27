m4                      := m4-1.4.17
m4_url                  := http://ftp.gnu.org/gnu/m4/$(m4).tar.xz

configure-m4-rule:
	cd $(m4) && ./$(configure) \
		--disable-rpath \
		--enable-assert \
		--enable-c++ \
		--enable-changeword \
		--enable-gcc-warnings \
		--enable-threads=posix \
		--without-included-regex

build-m4-rule:
	$(MAKE) -C $(m4) all

install-m4-rule: $(call installed,glibc)
	$(MAKE) -C $(m4) install
