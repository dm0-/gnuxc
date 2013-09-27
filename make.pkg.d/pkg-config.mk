pkg-config              := pkg-config-0.28
pkg-config_url          := http://pkg-config.freedesktop.org/releases/$(pkg-config).tar.gz

ifeq ($(host),$(build))
export PKG_CONFIG        = /usr/bin/pkg-config
else
export PKG_CONFIG        = /usr/bin/$(host)-pkg-config --define-variable=prefix=/usr
export PKG_CONFIG_LIBDIR = $(sysroot)/usr/lib/pkgconfig
export PKG_CONFIG_PATH   = $(PKG_CONFIG_LIBDIR):$(sysroot)/usr/share/pkgconfig
endif

configure-pkg-config-rule:
	cd $(pkg-config) && ./$(configure) \
		--disable-host-tool \
		--disable-silent-rules \
		--with-pc-path=/usr/lib/pkgconfig:/usr/share/pkgconfig \
		--with-system-include-path=/usr/include \
		--with-system-library-path=/usr/lib:/lib \
		--without-internal-glib

build-pkg-config-rule:
	$(MAKE) -C $(pkg-config) all

install-pkg-config-rule: $(call installed,glib)
	$(MAKE) -C $(pkg-config) install
