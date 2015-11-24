wdiff                   := wdiff-1.2.2
wdiff_url               := http://ftpmirror.gnu.org/wdiff/$(wdiff).tar.gz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-rpath \
		--enable-experimental \
		--enable-threads=posix \
		--without-included-regex \
		--with-termcap=tinfo

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,diffutils ncurses)
	$(MAKE) -C $(builddir) install
