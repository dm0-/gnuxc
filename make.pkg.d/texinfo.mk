texinfo                 := texinfo-6.1
texinfo_sha1            := d39c2e35ddb0aff6ebdd323ce53729bd215534fa
texinfo_url             := http://ftpmirror.gnu.org/texinfo/$(texinfo).tar.xz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-rpath \
		--enable-perl-api-texi-build \
		--enable-perl-xs \
		--enable-threads=posix \
		--without-included-regex

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,ncurses zlib)
	$(MAKE) -C $(builddir) install
