m4                      := m4-1.4.18
m4_key                  := 71C2CC22B1C4602927D2F3AAA7A16B4A2527436A
m4_url                  := http://ftpmirror.gnu.org/m4/$(m4).tar.xz

export M4 = /usr/bin/m4

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-rpath \
		--enable-assert \
		--enable-c++ \
		--enable-changeword \
		--enable-gcc-warnings gl_cv_warn_c__Werror=no \
		--enable-threads=posix \
		--without-included-regex

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,glibc)
	$(MAKE) -C $(builddir) install
