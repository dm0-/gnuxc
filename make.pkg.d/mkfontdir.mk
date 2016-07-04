mkfontdir               := mkfontdir-1.0.7
mkfontdir_sha1          := 3c06dad8a5fbf7362b51fb7d6b1ab805eba40336
mkfontdir_url           := http://xorg.freedesktop.org/releases/individual/app/$(mkfontdir).tar.bz2

export MKFONTDIR = /usr/bin/mkfontdir

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules \
		--enable-strict-compilation

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,mkfontscale)
	$(MAKE) -C $(builddir) install
