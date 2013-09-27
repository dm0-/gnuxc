xinit                   := xinit-1.3.3
xinit_url               := http://xorg.freedesktop.org/releases/individual/app/$(xinit).tar.bz2

configure-xinit-rule:
	cd $(xinit) && ./$(configure) \
		--disable-silent-rules \
		--with-xinitdir='$${sysconfdir}/X11/xinit' \
		\
		--disable-strict-compilation

build-xinit-rule:
	$(MAKE) -C $(xinit) all

install-xinit-rule: $(call installed,xauth xorg-server)
	$(MAKE) -C $(xinit) install
