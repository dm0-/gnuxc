expat                   := expat-2.2.0
expat_sha1              := 8453bc52324be4c796fd38742ec48470eef358b3
expat_url               := http://prdownloads.sourceforge.net/expat/$(expat).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure)

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,glibc)
	$(MAKE) -C $(builddir) install \
		DESTDIR='$(DESTDIR)'
