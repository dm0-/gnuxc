libxshmfence            := libxshmfence-1.2
libxshmfence_key        := C383B778255613DFDB409D91DB221A6900000011
libxshmfence_url        := http://xorg.freedesktop.org/releases/individual/lib/$(libxshmfence).tar.bz2

$(prepare-rule):
# Installed headers include xproto headers.
	$(ECHO) 'Requires: xproto' >> $(builddir)/xshmfence.pc.in

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,xproto)
	$(MAKE) -C $(builddir) install
