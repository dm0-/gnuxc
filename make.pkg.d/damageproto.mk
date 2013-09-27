damageproto             := damageproto-1.2.1
damageproto_url         := http://xorg.freedesktop.org/releases/individual/proto/$(damageproto).tar.bz2

configure-damageproto-rule:
	cd $(damageproto) && ./$(configure) \
		--enable-strict-compilation

build-damageproto-rule:
	$(MAKE) -C $(damageproto) all

install-damageproto-rule: $(call installed,xextproto)
	$(MAKE) -C $(damageproto) install
