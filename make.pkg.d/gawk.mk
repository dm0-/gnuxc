gawk                    := gawk-4.1.3
gawk_sha1               := 4e92b54f0a9ecbb9c2cfc0d2deb43be4d1f8e0d0
gawk_url                := http://ftpmirror.gnu.org/gawk/$(gawk).tar.lz

export AWK = /usr/bin/gawk

$(prepare-rule):
	$(EDIT) 's/\(_found_readline\)=no/\1=yes/' $(builddir)/configure

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-rpath \
		--enable-extensions \
		--with-mpfr \
		--with-readline

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,mpfr readline)
	$(MAKE) -C $(builddir) install
