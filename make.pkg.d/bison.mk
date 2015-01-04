bison                   := bison-3.0.2
bison_url               := http://ftpmirror.gnu.org/bison/$(bison).tar.xz

configure-bison-rule:
	cd $(bison) && ./$(configure) \
		--disable-rpath \
		--disable-silent-rules \
		--enable-assert \
		--enable-gcc-warnings \
		--enable-threads=posix \
		--enable-yacc

build-bison-rule:
ifneq ($(host),$(build))
	$(MAKE) -C $(bison) lib/{configmake,errno,fcntl,stdio,string,unistd}.h
	$(MAKE) -C $(bison) src/bison
	$(TOUCH) $(bison)/doc/bison.help
	$(TOUCH) $(bison)/doc/bison.1
endif
	$(MAKE) -C $(bison) all

install-bison-rule: $(call installed,m4)
	$(MAKE) -C $(bison) install
