gawk                    := gawk-4.1.4
gawk_sha1               := ef6f23c5288c92f9dac736615161069a8abb14c2
gawk_url                := http://ftpmirror.gnu.org/gawk/$(gawk).tar.lz

export AWK = /usr/bin/gawk

$(prepare-rule):
	$(EDIT) 's/\(_found_readline\)=no/\1=yes/' $(builddir)/configure

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-rpath \
		--enable-extensions \
		--enable-lint \
		--with-mpfr \
		--with-readline

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,mpfr readline)
	$(MAKE) -C $(builddir) install
