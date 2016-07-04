xineramaproto           := xineramaproto-1.2.1
xineramaproto_sha1      := 818bffc16139d6e3de4344c83f00c495d3536753
xineramaproto_url       := http://xorg.freedesktop.org/releases/individual/proto/$(xineramaproto).tar.bz2

$(prepare-rule):
# Installed headers use types defined in xproto headers.
	$(ECHO) 'Requires: xproto' >> $(builddir)/xineramaproto.pc.in

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-strict-compilation

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,xproto)
	$(MAKE) -C $(builddir) install
