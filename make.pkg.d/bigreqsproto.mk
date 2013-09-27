bigreqsproto            := bigreqsproto-1.1.2
bigreqsproto_url        := http://xorg.freedesktop.org/releases/individual/proto/$(bigreqsproto).tar.bz2

configure-bigreqsproto-rule:
	cd $(bigreqsproto) && ./$(configure) \
		--enable-strict-compilation

build-bigreqsproto-rule:
	$(MAKE) -C $(bigreqsproto) all

install-bigreqsproto-rule: $(call installed,xextproto)
	$(MAKE) -C $(bigreqsproto) install
