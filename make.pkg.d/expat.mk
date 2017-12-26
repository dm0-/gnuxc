expat                   := expat-2.2.5
expat_sha1              := 490659abd7d6c6d4cb4e60c945a15fbf081564f6
expat_url               := http://prdownloads.sourceforge.net/expat/$(expat).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure)

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,glibc)
	$(MAKE) -C $(builddir) install \
		DESTDIR='$(DESTDIR)'
