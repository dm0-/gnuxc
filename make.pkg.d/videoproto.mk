videoproto              := videoproto-2.3.2
videoproto_url          := http://xorg.freedesktop.org/releases/individual/proto/$(videoproto).tar.bz2

configure-videoproto-rule:
	cd $(videoproto) && ./$(configure) \
		--enable-strict-compilation

build-videoproto-rule:
	$(MAKE) -C $(videoproto) all

install-videoproto-rule: $(call installed,xextproto)
	$(MAKE) -C $(videoproto) install
