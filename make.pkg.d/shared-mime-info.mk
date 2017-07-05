shared-mime-info        := shared-mime-info-1.8
shared-mime-info_sha1   := d7ea6a4e7537065de5d0766148be804eb4729cb7
shared-mime-info_url    := http://freedesktop.org/~hadess/$(shared-mime-info).tar.xz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules \
		--disable-update-mimedb

$(build-rule):
	$(MAKE) -C $(builddir) -j1 all

$(install-rule): $$(call installed,glib libxml2)
	$(MAKE) -C $(builddir) install
