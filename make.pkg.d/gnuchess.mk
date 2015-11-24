gnuchess                := gnuchess-6.2.2
gnuchess_url            := http://ftpmirror.gnu.org/chess/$(gnuchess).tar.gz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-rpath \
		--with-readline

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,readline)
	$(MAKE) -C $(builddir) install
