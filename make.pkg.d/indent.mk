indent                  := indent-2.2.10
indent_url              := http://ftpmirror.gnu.org/indent/$(indent).tar.gz

configure-indent-rule:
	cd $(indent) && ./$(configure) \
		--disable-rpath

build-indent-rule:
	$(MAKE) -C $(indent) all

install-indent-rule: $(call installed,glibc)
	$(MAKE) -C $(indent) install \
		docdir='$$(datarootdir)/doc/indent'
