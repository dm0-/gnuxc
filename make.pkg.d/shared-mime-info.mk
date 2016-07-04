shared-mime-info        := shared-mime-info-1.6
shared-mime-info_sha1   := 9860e569b4ac31423539f4cccfb5e54e2d28f8ab
shared-mime-info_url    := http://freedesktop.org/~hadess/$(shared-mime-info).tar.xz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules \
		--disable-update-mimedb

$(build-rule):
	$(MAKE) -C $(builddir) -j1 all

$(install-rule): $$(call installed,glib libxml2)
	$(MAKE) -C $(builddir) install
