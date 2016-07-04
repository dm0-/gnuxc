pkg-config              := pkg-config-0.29.1
pkg-config_sha1         := 271ce928f6d673cc16cbced2bfd14a5f2e5d3d37
pkg-config_url          := http://pkg-config.freedesktop.org/releases/$(pkg-config).tar.gz

ifeq ($(host),$(build))
export PKG_CONFIG = /usr/bin/pkg-config
else
export PKG_CONFIG = /usr/bin/$(host)-pkg-config --define-variable=prefix=/usr
endif

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-host-tool \
		--disable-silent-rules \
		--with-pc-path=/usr/lib/pkgconfig:/usr/share/pkgconfig \
		--with-system-include-path=/usr/include \
		--with-system-library-path=/usr/lib:/lib \
		--without-internal-glib

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,glib)
	$(MAKE) -C $(builddir) install
