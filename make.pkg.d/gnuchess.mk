gnuchess                := gnuchess-6.2.5
gnuchess_key            := 766D3CA0FFB903333D2AE492A8AB893AE40251D9
gnuchess_url            := http://ftpmirror.gnu.org/chess/$(gnuchess).tar.gz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-rpath \
		--with-readline

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,readline)
	$(MAKE) -C $(builddir) install
