wdiff                   := wdiff-1.2.2
wdiff_key               := 7E817CE6A4421C82B3FCA4E7461A7AA389BD745B
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
