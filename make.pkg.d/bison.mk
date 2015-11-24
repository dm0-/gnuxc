bison                   := bison-3.0.4
bison_url               := http://ftpmirror.gnu.org/bison/$(bison).tar.xz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-rpath \
		--disable-silent-rules \
		--enable-assert \
		--enable-gcc-warnings \
		--enable-threads=posix \
		--enable-yacc

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,m4)
	$(MAKE) -C $(builddir) install
