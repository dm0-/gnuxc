indent                  := indent-2.2.10
indent_key              := 7EE3B78D09405C550215A94C57851A24D9FC8D73
indent_url              := http://ftpmirror.gnu.org/indent/$(indent).tar.gz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-rpath

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,glibc)
	$(MAKE) -C $(builddir) install \
		docdir='$$(datarootdir)/doc/indent'
