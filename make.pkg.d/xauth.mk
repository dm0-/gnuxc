xauth                   := xauth-1.0.10
xauth_key               := 3BB639E56F861FA2E86505690FDD682D974CA72A
xauth_url               := http://xorg.freedesktop.org/releases/individual/app/$(xauth).tar.bz2

export MCOOKIE = /usr/bin/mcookie

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-ipv6 \
		--enable-local-transport \
		--enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no \
		--enable-tcp-transport \
		--enable-unix-transport

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,libXmu)
	$(MAKE) -C $(builddir) install
	$(INSTALL) -Dpm 0755 $(call addon-file,mcookie.sh) $(DESTDIR)/usr/bin/mcookie

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
