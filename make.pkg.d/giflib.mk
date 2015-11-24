giflib                  := giflib-5.1.1
giflib_url              := http://prdownloads.sourceforge.net/giflib/$(giflib).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,glibc)
	$(MAKE) -C $(builddir) install
