atk                     := atk-2.18.0
atk_url                 := http://ftp.gnome.org/pub/gnome/sources/atk/2.18/$(atk).tar.xz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules \
		--enable-compile-warnings \
		--enable-iso-c \
		--enable-static

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,glib)
	$(MAKE) -C $(builddir) install
