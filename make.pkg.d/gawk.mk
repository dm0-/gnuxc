gawk                    := gawk-4.1.0
gawk_url                := http://ftp.gnu.org/gnu/gawk/$(gawk).tar.xz

export AWK = /usr/bin/gawk

prepare-gawk-rule:
	$(EDIT) 's/\(_found_readline\)=no/\1=yes/' $(gawk)/configure
	$(EDIT) '/check-for-shared-lib-support/,/^$$/d' $(gawk)/extension/Makefile.in

configure-gawk-rule:
	cd $(gawk) && ./$(configure) \
		--disable-rpath \
		--with-mpfr \
		--with-readline

build-gawk-rule:
	$(MAKE) -C $(gawk) all \
		CPPFLAGS=-DMAXPATHLEN=4096

install-gawk-rule: $(call installed,mpfr readline)
	$(MAKE) -C $(gawk) install
