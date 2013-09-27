texinfo                 := texinfo-5.1.90
texinfo_url             := http://alpha.gnu.org/gnu/texinfo/$(texinfo).tar.xz

configure-texinfo-rule:
	cd $(texinfo) && ./$(configure) \
		--disable-rpath \
		--enable-threads=posix \
		--without-included-regex

build-texinfo-rule:
	$(MAKE) -C $(texinfo) all

install-texinfo-rule: $(call installed,ncurses zlib)
	$(MAKE) -C $(texinfo) install
