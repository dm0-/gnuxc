m4                      := m4-1.4.17
m4_sha1                 := 74ad71fa100ec8c13bc715082757eb9ab1e4bbb0
m4_url                  := http://ftpmirror.gnu.org/m4/$(m4).tar.xz

export M4 = /usr/bin/m4

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-rpath \
		--enable-assert \
		--enable-c++ \
		--enable-changeword \
		--enable-gcc-warnings \
		--enable-threads=posix \
		--without-included-regex

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,glibc)
	$(MAKE) -C $(builddir) install
