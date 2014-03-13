coreutils               := coreutils-8.22
coreutils_url           := http://ftp.gnu.org/gnu/coreutils/$(coreutils).tar.xz

prepare-coreutils-rule:
	$(PATCH) -d $(coreutils) < $(patchdir)/$(coreutils)-add-hurd-term.patch
ifneq ($(host),$(build))
	$(EDIT) \
		-e '/run_help2man/{/SHELL/s/^@[^@]*@//;/PERL/s/^@[^@]*@/#/;}' \
		-e '/^[ \t]*--output=/{h;d};/^[ \t]*--info-page=/G' \
		$(coreutils)/Makefile.in
endif

configure-coreutils-rule:
	cd $(coreutils) && ./$(configure) \
		--exec-prefix= \
		--libexecdir='$${prefix}/libexec' \
		\
		--disable-silent-rules \
		--disable-rpath \
		--enable-acl \
		--enable-assert \
		--enable-gcc-warnings gl_cv_warn_c__Werror=no \
		--enable-no-install-program= \
		--enable-threads=posix \
		--enable-xattr \
		--with-gmp \
		--without-included-regex \
		\
		--disable-libcap \
		--disable-libsmack \
		--without-selinux

build-coreutils-rule:
	$(MAKE) -C $(coreutils) all

install-coreutils-rule: $(call installed,acl gmp libpthread)
	$(MAKE) -C $(coreutils) install
	$(INSTALL) -dm 755 $(DESTDIR)/usr/bin
	$(SYMLINK) ../../bin/env $(DESTDIR)/usr/bin/env
