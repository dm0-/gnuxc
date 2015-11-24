texinfo                 := texinfo-6.0
texinfo_url             := http://ftpmirror.gnu.org/texinfo/$(texinfo).tar.xz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-rpath \
		--enable-threads=posix \
		--without-included-regex

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,ncurses zlib)
	$(MAKE) -C $(builddir) install
