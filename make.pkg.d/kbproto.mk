kbproto                 := kbproto-1.0.6
kbproto_url             := http://xorg.freedesktop.org/releases/individual/proto/$(kbproto).tar.bz2

configure-kbproto-rule:
	cd $(kbproto) && ./$(configure) \
		--enable-strict-compilation

build-kbproto-rule:
	$(MAKE) -C $(kbproto) all

install-kbproto-rule: $(call installed,xextproto)
	$(MAKE) -C $(kbproto) install
