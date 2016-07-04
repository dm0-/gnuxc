giflib                  := giflib-5.1.4
giflib_sha1             := 5f1157cfc377916280849e247b8e34fa0446513f
giflib_url              := http://prdownloads.sourceforge.net/giflib/$(giflib).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,glibc)
	$(MAKE) -C $(builddir) install
