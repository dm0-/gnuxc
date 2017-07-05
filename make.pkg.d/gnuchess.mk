gnuchess                := gnuchess-6.2.4
gnuchess_sha1           := 2dfc9eed04e51c4a57a5f8ea885234aac0269dd1
gnuchess_url            := http://ftpmirror.gnu.org/chess/$(gnuchess).tar.gz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-rpath \
		--with-readline

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,readline)
	$(MAKE) -C $(builddir) install
