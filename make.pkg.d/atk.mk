atk                     := atk-2.24.0
atk_sha1                := 499fa622ea7c12ba15bef1b270a95d14607e3b67
atk_url                 := http://ftp.gnome.org/pub/gnome/sources/atk/2.24/$(atk).tar.xz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-rpath \
		--disable-silent-rules \
		--enable-static

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,glib)
	$(MAKE) -C $(builddir) install
