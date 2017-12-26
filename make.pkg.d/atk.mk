atk                     := atk-2.26.1
atk_sha1                := 78f33bdbacbc447c86a357690417c1b70e7664fc
atk_url                 := http://ftp.gnome.org/pub/gnome/sources/atk/2.26/$(atk).tar.xz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-rpath \
		--enable-static

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,glib)
	$(MAKE) -C $(builddir) install
