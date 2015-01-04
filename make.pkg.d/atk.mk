atk                     := atk-2.14.0
atk_url                 := http://ftp.gnome.org/pub/gnome/sources/atk/2.14/$(atk).tar.xz

configure-atk-rule:
	cd $(atk) && ./$(configure) \
		--disable-silent-rules \
		--enable-compile-warnings \
		--enable-iso-c \
		--enable-static

build-atk-rule:
	$(MAKE) -C $(atk) all

install-atk-rule: $(call installed,glib)
	$(MAKE) -C $(atk) install
