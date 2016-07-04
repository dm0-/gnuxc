gnuchess                := gnuchess-6.2.2
gnuchess_sha1           := 98e4ef7837b84b7e1e01f4cc74e9d1831ca485e5
gnuchess_url            := http://ftpmirror.gnu.org/chess/$(gnuchess).tar.gz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-rpath \
		--with-readline

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,readline)
	$(MAKE) -C $(builddir) install
