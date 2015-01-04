xauth                   := xauth-1.0.9
xauth_url               := http://xorg.freedesktop.org/releases/individual/app/$(xauth).tar.bz2

export MCOOKIE = /usr/bin/mcookie

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

# Provide a dumb placeholder for util-linux's "mcookie" command.
$(xauth)/mcookie.sh: | $(xauth)
	$(ECHO) '#!$(BASH) -e' > $@
	$(ECHO) -e 'for i in {1..16}\ndo' >> $@
	$(ECHO) "        printf '%02x' "'$$(( RANDOM % 256 ))' >> $@
	$(ECHO) -e 'done\necho' >> $@
$(call prepared,xauth): $(xauth)/mcookie.sh
