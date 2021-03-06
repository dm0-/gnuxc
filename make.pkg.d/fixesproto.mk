fixesproto              := fixesproto-5.0
fixesproto_sha1         := ab605af5da8c98c0c2f8b2c578fed7c864ee996a
fixesproto_url          := http://xorg.freedesktop.org/releases/individual/proto/$(fixesproto).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-strict-compilation

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,xextproto)
	$(MAKE) -C $(builddir) install
