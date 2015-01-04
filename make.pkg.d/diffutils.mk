diffutils               := diffutils-3.3
diffutils_url           := http://ftpmirror.gnu.org/diffutils/$(diffutils).tar.xz

configure-diffutils-rule:
	cd $(diffutils) && ./$(configure) \
		--disable-rpath \
		--disable-silent-rules \
		--without-included-regex

build-diffutils-rule:
	$(MAKE) -C $(diffutils) all

install-diffutils-rule: $(call installed,glibc)
	$(MAKE) -C $(diffutils) install
