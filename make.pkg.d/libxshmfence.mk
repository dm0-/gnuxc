libxshmfence            := libxshmfence-1.2
libxshmfence_sha1       := a2ebe90e5595afca4db93a4359732af43b2b8c69
libxshmfence_url        := http://xorg.freedesktop.org/releases/individual/lib/$(libxshmfence).tar.bz2

$(prepare-rule):
# Installed headers include xproto headers.
	$(ECHO) 'Requires: xproto' >> $(builddir)/xshmfence.pc.in

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules \
		--enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,xproto)
	$(MAKE) -C $(builddir) install
