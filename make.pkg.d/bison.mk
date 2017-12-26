bison                   := bison-3.0.4
bison_key               := 7DF84374B1EE1F9764BBE25D0DDCAA3278D5264E
bison_url               := http://ftpmirror.gnu.org/bison/$(bison).tar.xz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-rpath \
		--enable-assert \
		--enable-gcc-warnings \
		--enable-threads=posix \
		--enable-yacc

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,m4)
	$(MAKE) -C $(builddir) install
