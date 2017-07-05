xauth                   := xauth-1.0.10
xauth_sha1              := 87946b2af3ff13705d8eb60adae5c0bcdf839967
xauth_url               := http://xorg.freedesktop.org/releases/individual/app/$(xauth).tar.bz2

export MCOOKIE = /usr/bin/mcookie

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules \
		--enable-ipv6 \
		--enable-local-transport \
		--enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no \
		--enable-tcp-transport \
		--enable-unix-transport

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,libXmu)
	$(MAKE) -C $(builddir) install
	$(INSTALL) -Dpm 755 $(call addon-file,mcookie.sh) $(DESTDIR)/usr/bin/mcookie

# Write inline files.
$(call addon-file,mcookie.sh): | $$(@D)
	$(file >$@,$(contents))
$(prepared): $(call addon-file,mcookie.sh)


# Provide a dumb placeholder for util-linux's "mcookie" command.
override define contents
#!/bin/bash -e
for i in {1..16}
do
        printf '%02x' $(( RANDOM % 256 ))
done
echo
endef
$(call addon-file,mcookie.sh): private override contents := $(value contents)
