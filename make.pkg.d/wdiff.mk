wdiff                   := wdiff-1.2.2
wdiff_url               := http://ftpmirror.gnu.org/wdiff/$(wdiff).tar.gz

configure-wdiff-rule:
	cd $(wdiff) && ./$(configure) \
		--disable-rpath \
		--enable-experimental \
		--enable-threads=posix \
		--without-included-regex \
		--with-termcap=tinfo

build-wdiff-rule:
	$(MAKE) -C $(wdiff) all

install-wdiff-rule: $(call installed,diffutils ncurses)
	$(MAKE) -C $(wdiff) install
