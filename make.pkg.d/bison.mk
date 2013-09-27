bison                   := bison-3.0
bison_url               := http://ftp.gnu.org/gnu/bison/$(bison).tar.xz

configure-bison-rule:
	cd $(bison) && ./$(configure) \
		--disable-rpath \
		--disable-silent-rules \
		--enable-gcc-warnings \
		--enable-threads=posix \
		--enable-yacc

build-bison-rule:
	$(MAKE) -C $(bison) lib/{configmake,fcntl,string}.h
	$(MAKE) -C $(bison) src/bison
	$(TOUCH) $(bison)/doc/bison.help
	$(TOUCH) $(bison)/doc/bison.1
	$(MAKE) -C $(bison) all

install-bison-rule: $(call installed,m4)
	$(MAKE) -C $(bison) install
