renderproto             := renderproto-0.11.1
renderproto_url         := http://xorg.freedesktop.org/releases/individual/proto/$(renderproto).tar.bz2

configure-renderproto-rule:
	cd $(renderproto) && ./$(configure) \
		--enable-strict-compilation

build-renderproto-rule:
	$(MAKE) -C $(renderproto) all

install-renderproto-rule: $(call installed,xextproto)
	$(MAKE) -C $(renderproto) install
