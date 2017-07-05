expat                   := expat-2.2.1
expat_sha1              := f45eb724f182776a9cacec9ed70d549e87198987
expat_url               := http://prdownloads.sourceforge.net/expat/$(expat).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure)

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,glibc)
	$(MAKE) -C $(builddir) install \
		DESTDIR='$(DESTDIR)'
