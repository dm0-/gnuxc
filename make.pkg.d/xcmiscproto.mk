xcmiscproto             := xcmiscproto-1.2.2
xcmiscproto_url         := http://xorg.freedesktop.org/releases/individual/proto/$(xcmiscproto).tar.bz2

configure-xcmiscproto-rule:
	cd $(xcmiscproto) && ./$(configure) \
		--enable-strict-compilation

build-xcmiscproto-rule:
	$(MAKE) -C $(xcmiscproto) all

install-xcmiscproto-rule: $(call installed,xextproto)
	$(MAKE) -C $(xcmiscproto) install
