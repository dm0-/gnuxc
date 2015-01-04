gawk                    := gawk-4.1.1
gawk_url                := http://ftpmirror.gnu.org/gawk/$(gawk).tar.xz

export AWK = /usr/bin/gawk

prepare-gawk-rule:
	$(EDIT) 's/\(_found_readline\)=no/\1=yes/' $(gawk)/configure

configure-gawk-rule:
	cd $(gawk) && ./$(configure) \
		--disable-rpath \
		--enable-extensions \
		--with-mpfr \
		--with-readline

build-gawk-rule:
	$(MAKE) -C $(gawk) all

install-gawk-rule: $(call installed,mpfr readline)
	$(MAKE) -C $(gawk) install
