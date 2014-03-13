xauth                   := xauth-1.0.8
xauth_url               := http://xorg.freedesktop.org/releases/individual/app/$(xauth).tar.bz2

export MCOOKIE = /usr/bin/mcookie

prepare-xauth-rule:
	$(ECHO) '#!/bin/bash' > $(xauth)/mcookie.sh
	$(ECHO) -e 'for i in {1..16}\ndo' >> $(xauth)/mcookie.sh
	$(ECHO) "        printf '%02x' "'$$(( RANDOM % 256 ))' >> $(xauth)/mcookie.sh
	$(ECHO) -e 'done\necho' >> $(xauth)/mcookie.sh

configure-xauth-rule:
	cd $(xauth) && ./$(configure) \
		--disable-silent-rules \
		--enable-ipv6 \
		--enable-local-transport \
		--enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no \
		--enable-tcp-transport \
		--enable-unix-transport

build-xauth-rule:
	$(MAKE) -C $(xauth) all

install-xauth-rule: $(call installed,libXmu)
	$(MAKE) -C $(xauth) install
	$(INSTALL) -Dpm 755 $(xauth)/mcookie.sh $(DESTDIR)/usr/bin/mcookie
