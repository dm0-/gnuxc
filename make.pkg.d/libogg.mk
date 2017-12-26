libogg                  := libogg-1.3.3
libogg_sha1             := ba54760b8f44bd85b79222286faf5d6a21e356fe
libogg_url              := http://downloads.xiph.org/releases/ogg/$(libogg).tar.xz

$(configure-rule):
	cd $(builddir) && ./$(configure)

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,glibc)
	$(MAKE) -C $(builddir) install
