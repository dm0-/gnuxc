pkg-config              := pkg-config-0.29.2
pkg-config_key          := 6B99CE97F17F48C27F722D71023A4420C7EC6914
pkg-config_url          := http://pkg-config.freedesktop.org/releases/$(pkg-config).tar.gz
pkg-config_sig          := $(pkg-config_url).asc

ifeq ($(host),$(build))
export PKG_CONFIG = /usr/bin/pkg-config
else
export PKG_CONFIG = /usr/bin/$(host)-pkg-config --define-variable=prefix=/usr
endif

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-host-tool \
		--with-pc-path=/usr/lib/pkgconfig:/usr/share/pkgconfig \
		--with-system-include-path=/usr/include \
		--with-system-library-path=/usr/lib:/lib \
		--without-internal-glib

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,glib)
	$(MAKE) -C $(builddir) install
