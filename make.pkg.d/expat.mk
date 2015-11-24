expat                   := expat-2.1.0
expat_url               := http://prdownloads.sourceforge.net/expat/$(expat).tar.gz

$(configure-rule):
	cd $(builddir) && ./$(configure)

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,glibc)
	$(MAKE) -C $(builddir) install \
		DESTDIR='$(DESTDIR)'
