indent                  := indent-2.2.10
indent_url              := http://ftpmirror.gnu.org/indent/$(indent).tar.gz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-rpath

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,glibc)
	$(MAKE) -C $(builddir) install \
		docdir='$$(datarootdir)/doc/indent'
