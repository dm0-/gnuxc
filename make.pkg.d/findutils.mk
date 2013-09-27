findutils               := findutils-4.5.12
findutils_url           := http://alpha.gnu.org/gnu/findutils/$(findutils).tar.gz

configure-findutils-rule:
	cd $(findutils) && ./$(configure) \
		--disable-rpath \
		--enable-assert \
		--enable-compiler-warnings \
		--enable-debug \
		--enable-d_type-optimization \
		--enable-leaf-optimisation \
		--enable-threads=posix \
		--without-included-regex \
		\
		--without-selinux

build-findutils-rule:
	$(MAKE) -C $(findutils) all

install-findutils-rule: $(call installed,glibc)
	$(MAKE) -C $(findutils) install
