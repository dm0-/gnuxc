texinfo                 := texinfo-5.2
texinfo_url             := http://ftpmirror.gnu.org/texinfo/$(texinfo).tar.xz

configure-texinfo-rule:
	cd $(texinfo) && ./$(configure) \
		--disable-rpath \
		--enable-threads=posix \
		--without-included-regex

build-texinfo-rule:
	$(MAKE) -C $(texinfo) all

install-texinfo-rule: $(call installed,ncurses zlib)
	$(MAKE) -C $(texinfo) install
