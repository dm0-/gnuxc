atk                     := atk-2.20.0
atk_sha1                := 5d4d699721fee8bcecd3edf1361e89af1db06148
atk_url                 := http://ftp.gnome.org/pub/gnome/sources/atk/2.20/$(atk).tar.xz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-rpath \
		--disable-silent-rules \
		--enable-static

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,glib)
	$(MAKE) -C $(builddir) install
